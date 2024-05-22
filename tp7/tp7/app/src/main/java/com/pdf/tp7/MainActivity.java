package com.pdf.tp7;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private Button startServiceBtn, stopServiceBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        startServiceBtn = findViewById(R.id.startServiceBtn);
        stopServiceBtn = findViewById(R.id.stopServiceBtn);

        startServiceBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startService();
            }
        });

        stopServiceBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                stopService();
            }
        });
    }

    private void startService() {
        Intent serviceIntent = new Intent(this, FlashlightService.class);
        serviceIntent.setAction("start");
        startForegroundService(serviceIntent);
        startServiceBtn.setVisibility(View.GONE);
        stopServiceBtn.setVisibility(View.VISIBLE);
    }

    private void stopService() {
        Intent serviceIntent = new Intent(this, FlashlightService.class);
        serviceIntent.setAction("stop");
        startService(serviceIntent);
        startServiceBtn.setVisibility(View.VISIBLE);
        stopServiceBtn.setVisibility(View.GONE);
    }
}
