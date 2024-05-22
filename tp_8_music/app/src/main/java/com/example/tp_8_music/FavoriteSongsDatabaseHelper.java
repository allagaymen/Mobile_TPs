package com.example.tp_8_music;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import java.util.ArrayList;
import java.util.List;

public class FavoriteSongsDatabaseHelper extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "ListFavorite.db";
    private static final int DATABASE_VERSION = 1;
    private static final String TABLE_NAME = "favorite_songs";
    private static final String COLUMN_ID = "_id";
    private static final String COLUMN_TITLE = "title";
    private static final String COLUMN_ARTIST = "artist";
    private static final String COLUMN_FILE_PATH = "file_path";
    public FavoriteSongsDatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTableQuery = "CREATE TABLE " + TABLE_NAME + " (" +
                COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                COLUMN_TITLE + " TEXT, " +
                COLUMN_ARTIST + " TEXT, " +
                COLUMN_FILE_PATH + " TEXT)";
        db.execSQL(createTableQuery);
    }
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
        onCreate(db);
    }
    public void addFavoriteSong(Favorite song) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_TITLE, song.getTitle());
        values.put(COLUMN_ARTIST, song.getArtist());
        values.put(COLUMN_FILE_PATH, song.getFilePath());
        db.insert(TABLE_NAME, null, values);
        db.close();
    }
    public void deleteFavoriteSong(long id) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_NAME, COLUMN_ID + "=?", new String[]{String.valueOf(id)});
        db.close();
    }
    public List<Favorite> getAllFavoriteSongs() {
        List<Favorite> favoriteSongs = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_NAME, null);
        if (cursor.moveToFirst()) {
            do {
                @SuppressLint("Range") long id = cursor.getLong(cursor.getColumnIndex(COLUMN_ID));
                @SuppressLint("Range") String title = cursor.getString(cursor.getColumnIndex(COLUMN_TITLE));
                @SuppressLint("Range") String artist = cursor.getString(cursor.getColumnIndex(COLUMN_ARTIST));
                @SuppressLint("Range") String filePath = cursor.getString(cursor.getColumnIndex(COLUMN_FILE_PATH));
                favoriteSongs.add(new Favorite(id, title, artist, filePath));
            } while (cursor.moveToNext());
        }
        cursor.close();
        db.close();
        return favoriteSongs;
    }
    public boolean isSongFavorite(long id) {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT 1 FROM " + TABLE_NAME + " WHERE " + COLUMN_ID + " = ?", new String[]{String.valueOf(id)});
        boolean exists = cursor.moveToFirst();
        cursor.close();
        db.close();
        return exists;
    }
    public boolean isSongFavoriteByTitle(String title) {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT 1 FROM " + TABLE_NAME + " WHERE " + COLUMN_TITLE + " = ?", new String[]{title});
        boolean exists = cursor.moveToFirst();
        cursor.close();
        db.close();
        return exists;
    }
}

