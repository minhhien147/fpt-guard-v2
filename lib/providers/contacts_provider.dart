import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/database_service.dart';

class ContactsProvider with ChangeNotifier {
  List<ContactModel> _personalContacts = [];
  bool _isLoading = false;

  List<ContactModel> get personalContacts => _personalContacts;
  List<ContactModel> get allContacts => List.unmodifiable(_personalContacts);
  bool get isLoading => _isLoading;

  // Tải danh sách liên hệ cá nhân
  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _personalContacts = await DatabaseService.instance.getContacts();
    } catch (e) {
      print('Error loading contacts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm liên hệ mới
  Future<bool> addContact(ContactModel contact) async {
    try {
      final id = await DatabaseService.instance.insertContact(contact);
      final newContact = ContactModel(
        id: id,
        userId: contact.userId,
        contactName: contact.contactName,
        contactPhone: contact.contactPhone,
        contactEmail: contact.contactEmail,
        contactType: contact.contactType,
        createdAt: DateTime.now(),
      );
      
      _personalContacts.insert(0, newContact);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error adding contact: $e');
      return false;
    }
  }

  // Xóa liên hệ
  Future<bool> deleteContact(int id) async {
    try {
      await DatabaseService.instance.deleteContact(id);
      _personalContacts.removeWhere((contact) => contact.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting contact: $e');
      return false;
    }
  }

  // Lấy danh sách email để gửi SOS
  List<String> getEmergencyEmails() {
    return _personalContacts
        .where((contact) => contact.contactEmail != null && contact.contactEmail!.isNotEmpty)
        .map((contact) => contact.contactEmail!)
        .toList();
  }
}

