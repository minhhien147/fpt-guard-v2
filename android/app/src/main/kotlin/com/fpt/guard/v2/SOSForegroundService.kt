package com.fpt.guard.v2

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class SOSForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "fpt_guard_sos_channel"
        private const val CHANNEL_NAME = "SAFE GUARD Background Protection"
        private const val NOTIFICATION_ID = 1001
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = buildNotification()
        // Bắt buộc gọi startForeground để service được phép chạy ngầm
        startForeground(NOTIFICATION_ID, notification)
        // Service sẽ tiếp tục chạy cho đến khi app hoặc người dùng tắt
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        // Không hỗ trợ bound service
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(STOP_FOREGROUND_REMOVE)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val existingChannel = manager.getNotificationChannel(CHANNEL_ID)
            if (existingChannel == null) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_LOW
                ).apply {
                    description = "Giữ SAFE GUARD hoạt động ở chế độ nền để bảo vệ người dùng."
                }
                manager.createNotificationChannel(channel)
            }
        }
    }

    private fun buildNotification(): Notification {
        // Intent mở lại app (MainActivity)
        val openAppIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            openAppIntent,
            pendingFlags
        )

        // Action \"GỬI SOS\" – hiện tại mở app, nơi người dùng có thể bấm nút SOS lớn
        val sosActionIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            // Có thể thêm extra để sau này Flutter đọc và tự mở màn SOS
            putExtra("from_notification", true)
            putExtra("action", "open_sos")
        }

        val sosPendingIntent = PendingIntent.getActivity(
            this,
            1,
            sosActionIntent,
            pendingFlags
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("SAFE GUARD đang bảo vệ bạn")
            .setContentText("Ứng dụng đang chạy ngầm để hỗ trợ SOS và vị trí khẩn cấp.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .addAction(
                android.R.drawable.ic_dialog_alert,
                "GỬI SOS",
                sosPendingIntent
            )
            .build()
    }
}


