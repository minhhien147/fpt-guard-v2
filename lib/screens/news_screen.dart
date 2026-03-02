import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../widgets/custom_drawer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  static const int _pageSize = 20;

  List<NewsModel> _news = [];
  List<String> _categories = [];
  String _selectedCategory = 'Tất cả';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _total = 0;
  int _offset = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNews(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadNews({bool reset = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      if (reset) {
        _news = [];
        _offset = 0;
        _hasMore = true;
      }
    });

    try {
      final result = await ApiService.getNews(
        limit: _pageSize,
        offset: 0,
        category: _selectedCategory == 'Tất cả' ? null : _selectedCategory,
      );
      final fetched = result['news'] as List<NewsModel>;
      final cats = result['categories'] as List<String>;
      setState(() {
        _news = fetched;
        _total = result['total'] as int;
        _offset = fetched.length;
        _hasMore = fetched.length < _total;
        if (cats.isNotEmpty) _categories = cats;
      });
    } catch (e) {
      debugPrint('Error loading news: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final result = await ApiService.getNews(
        limit: _pageSize,
        offset: _offset,
        category: _selectedCategory == 'Tất cả' ? null : _selectedCategory,
      );
      final fetched = result['news'] as List<NewsModel>;
      setState(() {
        _news.addAll(fetched);
        _offset += fetched.length;
        _hasMore = _news.length < _total;
      });
    } catch (e) {
      debugPrint('Error loading more news: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      if (diff.inDays < 7) return '${diff.inDays} ngày trước';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'An ninh':
        return Colors.red;
      case 'Pháp luật':
        return Colors.blue;
      case 'Thời sự':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức An ninh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadNews(reset: true),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final allCats = ['Tất cả', ..._categories];
    return Container(
      height: 44,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: allCats.length,
        itemBuilder: (context, i) {
          final cat = allCats[i];
          final selected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (_) {
                if (cat != _selectedCategory) {
                  setState(() => _selectedCategory = cat);
                  _loadNews(reset: true);
                }
              },
              selectedColor: _categoryColor(cat).withAlpha(204),
              labelStyle: TextStyle(
                color: selected ? Colors.white : null,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có tin tức',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Kéo xuống để tải mới',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNews(reset: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        itemCount: _news.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _news.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = _news[index];
          return _NewsCard(
            news: item,
            formattedDate: _formatDate(item.published),
            categoryColor: _categoryColor(item.category),
            onTap: () => _openUrl(item.link),
          );
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onTap;
  final String formattedDate;
  final Color categoryColor;

  const _NewsCard({
    required this.news,
    required this.onTap,
    required this.formattedDate,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: news.image != null
            ? _withImage(context)
            : _withoutImage(context),
      ),
    );
  }

  Widget _withImage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            news.image!,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        _textSection(context),
      ],
    );
  }

  Widget _withoutImage(BuildContext context) => _textSection(context);

  Widget _textSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: categoryColor.withAlpha(77)),
                ),
                child: Text(
                  news.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  news.source,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            news.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (news.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              news.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('Đọc thêm',
                    style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
