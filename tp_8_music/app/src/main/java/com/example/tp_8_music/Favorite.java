package com.example.tp_8_music;

public class Favorite {
    private long id;
    private String title;
    private String artist;
    private String filePath;
    public Favorite(long id, String title, String artist, String filePath) {
        this.id = id;
        this.title = title;
        this.artist = artist;
        this.filePath = filePath;
    }
    public long getId() {
        return id;
    }
    public String getTitle() {
        return title;
    }
    public String getArtist() {
        return artist;
    }
    public String getFilePath() {
        return filePath;
    }
}
