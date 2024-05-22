package com.example.tp_8_music;
import android.content.Context;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import java.util.ArrayList;
public class SongAdapter extends BaseAdapter {
    private ArrayList<Uri> audioUris;
    private LayoutInflater inflater;
    private OnItemClickListener onItemClickListener;
    public interface OnItemClickListener {
        void onItemClick(int position);
    }
    public SongAdapter(Context context, ArrayList<Uri> audioUris, OnItemClickListener onItemClickListener) {
        this.audioUris = audioUris;
        this.inflater = LayoutInflater.from(context);
        this.onItemClickListener = onItemClickListener;
    }
    @Override
    public int getCount() {
        return audioUris.size();
    }
    @Override
    public Object getItem(int position) {
        return audioUris.get(position);
    }
    @Override
    public long getItemId(int position) {
        return position;
    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = convertView;
        if (view == null) {
            view = inflater.inflate(R.layout.item_song, parent, false);
        }
        Uri songUri = audioUris.get(position);
        TextView songNameTextView = view.findViewById(R.id.songNameTextView);
        songNameTextView.setText(Common.getSongName(songUri));
        view.setOnClickListener(v -> {
            if (onItemClickListener != null) {
                onItemClickListener.onItemClick(position);
            }
        });
        return view;
    }
}

