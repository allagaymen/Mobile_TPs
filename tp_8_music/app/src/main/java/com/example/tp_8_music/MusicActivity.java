package com.example.tp_8_music;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
public class MusicActivity extends AppCompatActivity  {
    private ImageView play, previous, next, pause, favorite, showFavorite;
    private TextView songNameTextView;
    private ArrayList<Uri> audioUris;
    private int currentPlayingIndex;
    private FavoriteSongsDatabaseHelper favorisDataSource;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_music);

        play = findViewById(R.id.play);
        previous = findViewById(R.id.previous);
        next = findViewById(R.id.next);
        pause = findViewById(R.id.pause);
        favorite = findViewById(R.id.favorite);
        showFavorite = findViewById(R.id.showfavorite);
        songNameTextView = findViewById(R.id.songNameTextView);
        favorisDataSource = new FavoriteSongsDatabaseHelper(this);
        Intent intent = getIntent();
        Uri currentUri = intent.getData();
        currentPlayingIndex = intent.getIntExtra("currentPlayingIndex", 0);
        play.setOnClickListener(view -> playMusic(currentUri));
        pause.setOnClickListener(view -> pauseMusic());
        previous.setOnClickListener(view -> playPrevious());
        next.setOnClickListener(view -> playNext());
        favorite.setOnClickListener(view -> toggleFavorite());
        showFavorite.setOnClickListener(view -> openFavoritesActivity()); // Set the onClickListener
        audioUris = Common.getAllAudioFromStorage(this);
        songNameTextView.setText(Common.getSongName(currentUri)); // Update TextView with the current song name
        playMusic(currentUri); // Start playing the selected song when the activity is created
    }
    @Override
    protected void onResume() {
        super.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
    }
    private void openFavoritesActivity() {
        Intent intent = new Intent(this, FavoriteActivity.class);
        startActivity(intent);
    }
    private void playMusic(Uri musicUri) {
        startMusicService(musicUri, "PLAY");
        songNameTextView.setText(Common.getSongName(musicUri)); // Update TextView in the app
        play.setVisibility(View.GONE);
        pause.setVisibility(View.VISIBLE);
    }
    private void pauseMusic() {
        startMusicService(null, "PAUSE");
        play.setVisibility(View.VISIBLE);
        pause.setVisibility(View.GONE);
    }
    private void playPrevious() {
        if (audioUris != null && !audioUris.isEmpty()) {
            currentPlayingIndex = (currentPlayingIndex - 1 + audioUris.size()) % audioUris.size();
            Uri previousUri = audioUris.get(currentPlayingIndex);
            startMusicService(previousUri, "PREVIOUS");
            songNameTextView.setText(Common.getSongName(previousUri)); // Update TextView in the app
            play.setVisibility(View.GONE);
            pause.setVisibility(View.VISIBLE);
        }
    }
    private void playNext() {
        if (audioUris != null && !audioUris.isEmpty()) {
            currentPlayingIndex = (currentPlayingIndex + 1) % audioUris.size();
            Uri nextUri = audioUris.get(currentPlayingIndex);
            startMusicService(nextUri, "NEXT");
            songNameTextView.setText(Common.getSongName(nextUri)); // Update TextView in the app
            play.setVisibility(View.GONE);
            pause.setVisibility(View.VISIBLE);
        }
    }
    private void toggleFavorite() {    if (audioUris != null && !audioUris.isEmpty()) {
        Uri currentSongUri = audioUris.get(currentPlayingIndex);        String songName = Common.getSongName(currentSongUri);
        if (!favorisDataSource.isSongFavoriteByTitle(songName)) {
            Favorite favoriteSong = new Favorite(currentSongUri.hashCode(), songName, "Singer", currentSongUri.toString());favorisDataSource.addFavoriteSong(favoriteSong);
            Toast.makeText(this, "Song added to favorites", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Song already in favorites", Toast.LENGTH_SHORT).show();
        }
    }}
    private void startMusicService(Uri musicUri, String action) {
        Intent serviceIntent = new Intent(this, Service.class);
        serviceIntent.setAction(action);
        if (musicUri != null) {
            serviceIntent.setData(musicUri);
        }
        ContextCompat.startForegroundService(this, serviceIntent);
    }
}