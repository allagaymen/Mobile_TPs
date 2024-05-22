package com.example.tp_8_music;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;

import android.widget.ListView;

import java.util.List;

public class FavoriteActivity extends AppCompatActivity {
    private ListView favorislist;
    private ListAdapter listAdapter;
    private FavoriteSongsDatabaseHelper dataSource;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favorite);

        favorislist = findViewById(R.id.favoriteSongsListView);
        dataSource = new FavoriteSongsDatabaseHelper(this);

        List<Favorite> favoriteSongs = dataSource.getAllFavoriteSongs();

        listAdapter = new ListAdapter(this, (ArrayList<Favorite>) favoriteSongs, dataSource);
        favorislist.setAdapter(listAdapter);
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
