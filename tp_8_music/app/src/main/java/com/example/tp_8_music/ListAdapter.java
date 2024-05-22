package com.example.tp_8_music;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;

import java.util.ArrayList;
public class ListAdapter extends ArrayAdapter<Favorite> {
    private FavoriteSongsDatabaseHelper favorisDataSource;
    private Context context;
    public ListAdapter(Context context, ArrayList<Favorite> songs, FavoriteSongsDatabaseHelper favorisDataSource) {
        super(context, 0, songs);
        this.context = context;
        this.favorisDataSource = favorisDataSource;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Favorite song = getItem(position);

        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.favoris_item, parent, false);
        }
        ImageView albumArt = convertView.findViewById(R.id.album_art);
        TextView songTitle = convertView.findViewById(R.id.song_title);
        TextView songArtist = convertView.findViewById(R.id.song_artist);

        albumArt.setImageResource(R.drawable.like);
        songTitle.setText(song.getTitle());
        songArtist.setText(song.getArtist());

        convertView.setOnClickListener(v -> {
            Intent playIntent = new Intent(context, Service.class);
            playIntent.setAction("PLAY");
            playIntent.setData(Uri.parse(song.getFilePath())); // Pass the URI of the song to play
            context.startService(playIntent);
        });
        // Handle long click to remove item
        convertView.setOnLongClickListener(v -> {
            new AlertDialog.Builder(getContext())
                    .setTitle("Remove Song")
                    .setMessage("Please confirm your choice.")
                    .setPositiveButton(android.R.string.yes, (dialog, which) -> {
                        favorisDataSource.deleteFavoriteSong((int) song.getId());
                        remove(song);
                        notifyDataSetChanged();
                    })
                    .setNegativeButton(android.R.string.no, null)
                    .show();
            return true;
        });
        return convertView;
    }
}
