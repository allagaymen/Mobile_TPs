package com.example.tp_8_music;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
public class MainActivity extends AppCompatActivity {

    private ArrayList<Uri> audioUris;
    private FavoriteSongsDatabaseHelper favorisDataSource;
    private ListView listView;
    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        favorisDataSource = new FavoriteSongsDatabaseHelper(this);

        audioUris = getAllAudioFromStorage();

        listView = findViewById(R.id.listView);
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, getSongNames());
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Uri selectedSongUri = audioUris.get(position);
                Intent intent = new Intent(MainActivity.this, MusicActivity.class);
                intent.setData(selectedSongUri);
                intent.putExtra("currentPlayingIndex", position);
                startActivity(intent);
            }
        });
    }

    private ArrayList<Uri> getAllAudioFromStorage() {
        ArrayList<Uri> audioUris = new ArrayList<>();
        ContentResolver contentResolver = getContentResolver();
        Uri uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
        Cursor cursor = contentResolver.query(uri, null, null, null, null);

        if (cursor != null && cursor.moveToFirst()) {
            do {
                int columnIndex = cursor.getColumnIndex(MediaStore.Audio.Media.DATA);
                String audioPath = cursor.getString(columnIndex);
                audioUris.add(Uri.parse(audioPath));
            } while (cursor.moveToNext());

            cursor.close();
        }
        return audioUris;
    }
    private ArrayList<String> getSongNames() {
        ArrayList<String> songNames = new ArrayList<>();
        for (Uri uri : audioUris) {
            songNames.add(getSongName(uri));
        }
        return songNames;
    }
    private String getSongName(Uri musicUri) {
        if (musicUri == null) return "Unknown";
        String songName = musicUri.toString();
        int lastSlashIndex = songName.lastIndexOf('/');
        return songName.substring(lastSlashIndex + 1, songName.length() - 4);
    }
}
