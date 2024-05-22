package com.example.tp_8_music;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import java.util.ArrayList;
public class Common {
    public static String getSongName(Uri musicUri) {
        if (musicUri == null) return "Unknown";
        String songName = musicUri.toString();
        int lastSlashIndex = songName.lastIndexOf('/');
        return songName.substring(lastSlashIndex + 1, songName.length() - 4);
    }
    public static ArrayList<Uri> getAllAudioFromStorage(Context context) {
        ArrayList<Uri> audioUris = new ArrayList<>();
        ContentResolver contentResolver = context.getContentResolver();
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
}