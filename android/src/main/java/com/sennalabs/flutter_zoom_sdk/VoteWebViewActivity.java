package com.sennalabs.flutter_zoom_sdk;

import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

public class VoteWebViewActivity extends AppCompatActivity {
    private WebView webView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.vote_webview);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setTitle("ลงคะแนนเสียง");

        WebView browser = (WebView) findViewById(R.id.voteWebView);
        WebSettings webSettings = browser.getSettings();
        webSettings.setJavaScriptEnabled(true);

        Bundle extras = getIntent().getExtras();
        String url  =extras.getString("url");

        browser.loadUrl(url);
    }
    @Override
    public boolean onSupportNavigateUp() {
        finish();
        return true;
    }
}
