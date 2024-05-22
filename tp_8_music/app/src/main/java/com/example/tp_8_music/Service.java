package com.example.tp_8_music;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import androidx.core.app.NotificationCompat;
import java.io.IOException;
import java.util.ArrayList;

public class Service extends android.app.Service implements SensorEventListener {
    private MediaPlayer mediaPlayer;
    private boolean isShaking = false;
    private ArrayList<Uri> audioUris;
    private int currentPlayingIndex = 0;
    private boolean isPlaying = false;
    private int currentPlaybackPosition = 0;
    private boolean isPlaybackStopped = false;
    private SensorManager sensorManager;
    private Sensor accelerometerSensor;
    private static final float SHAKE_THRESHOLD = 25.0f;
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && intent.getAction() != null) {
            switch (intent.getAction()) {
                case "PLAY":
                    if (intent.getData() != null) {
                        currentPlayingIndex = audioUris.indexOf(intent.getData());
                    }
                    playMusic();
                    break;
                case "PAUSE":
                    pauseMusic();
                    break;
                case "PREVIOUS":
                    playPrevious();
                    break;
                case "NEXT":
                    playNext();
                    break;
            }
        }
        return START_NOT_STICKY;
    }
    private void sendBroadcastSongChanged(String songName) {
        Intent intent = new Intent("SONG_CHANGED");
        intent.putExtra("SONG_NAME", songName);
        sendBroadcast(intent);
    }
    private void pauseMusic() {
        if (isPlaying && mediaPlayer != null) {
            currentPlaybackPosition = mediaPlayer.getCurrentPosition();
            mediaPlayer.pause();
            isPlaying = false;
            isPlaybackStopped = true;
            showNotification();
        }
    }
    private void playPrevious() {
        if (audioUris != null && !audioUris.isEmpty()) {
            currentPlayingIndex = (currentPlayingIndex - 1 + audioUris.size()) % audioUris.size();
            playMusic();
        }
    }
    private void playNext() {
        if (audioUris != null && !audioUris.isEmpty()) {
            currentPlayingIndex = (currentPlayingIndex + 1) % audioUris.size();
            playMusic();
        }
    }
    private void playMusic() {
        if (audioUris != null && !audioUris.isEmpty()) {
            if (mediaPlayer != null) {
                mediaPlayer.release();
                mediaPlayer = null;
            }
            Uri currentUri = audioUris.get(currentPlayingIndex);
            mediaPlayer = new MediaPlayer();
            try {
                mediaPlayer.setDataSource(getApplicationContext(), currentUri);
                mediaPlayer.prepare();
                if (isPlaybackStopped) {
                    mediaPlayer.seekTo(currentPlaybackPosition);
                }
                mediaPlayer.start();
                isPlaying = true;
                isPlaybackStopped = false;
                showNotification();
                String songName = Common.getSongName(currentUri);
                sendBroadcastSongChanged(songName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    private void stopMusic() {
        if (mediaPlayer != null) {
            mediaPlayer.release();
            mediaPlayer = null;
            isPlaying = false;
        }
        stopForeground(true);
    }
    // Notification Service
    private void showNotification() {
        if (audioUris != null && !audioUris.isEmpty() && currentPlayingIndex >= 0 && currentPlayingIndex < audioUris.size()) {
            Uri currentUri = audioUris.get(currentPlayingIndex);
            String songName = Common.getSongName(currentUri);
            Intent playIntent = new Intent(this, Service.class);
            playIntent.setAction("PLAY");
            PendingIntent playPendingIntent = PendingIntent.getService(this, 0, playIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
            Intent pauseIntent = new Intent(this, Service.class);
            pauseIntent.setAction("PAUSE");
            PendingIntent pausePendingIntent = PendingIntent.getService(this, 0, pauseIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
            Intent previousIntent = new Intent(this, Service.class);
            previousIntent.setAction("PREVIOUS");
            PendingIntent previousPendingIntent = PendingIntent.getService(this, 0, previousIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
            Intent nextIntent = new Intent(this, Service.class);
            nextIntent.setAction("NEXT");
            PendingIntent nextPendingIntent = PendingIntent.getService(this, 0, nextIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
            Notification notification = new NotificationCompat.Builder(this, "MusicPlayer")
                    .setSmallIcon(R.drawable.logo)
                    .setContentTitle("Music Player")
                    .setContentText("Now Playing: " + songName)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setContentIntent(pausePendingIntent)
                    .addAction(R.drawable.previous, "Previous", previousPendingIntent)
                    .addAction(isPlaying ? R.drawable.pause : R.drawable.play, isPlaying ? "Pause" : "Play", isPlaying ? pausePendingIntent : playPendingIntent)
                    .addAction(R.drawable.next, "Next", nextPendingIntent)
                    .build();
            try {
                startForeground(1, notification);
            } catch (Exception e) {
                Log.e("Service", "Failed to start foreground service", e);
            }
        }
    }
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    "MusicPlayer",
                    "Music Player Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(serviceChannel);
            }
        }
    }
    // Sensor Service
    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
        audioUris = Common.getAllAudioFromStorage(this);

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        if (sensorManager != null) {
            accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
            if (accelerometerSensor != null) {
                sensorManager.registerListener(this, accelerometerSensor, SensorManager.SENSOR_DELAY_NORMAL);
            }
        }
    }
    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            float x = event.values[0];
            float y = event.values[1];
            float z = event.values[2];

            double magnitude = Math.sqrt(x * x + y * y + z * z);

            if (magnitude > SHAKE_THRESHOLD) {
                if (!isShaking) {
                    isShaking = true;
                    if (isPlaying) {
                        pauseMusic();
                    } else {
                        playMusic();
                    }
                }
            } else {
                isShaking = false;
            }
        }
    }
    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Not needed for this implementation
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
        if (sensorManager != null) {
            sensorManager.unregisterListener(this);
        }
        stopMusic();
    }
}
