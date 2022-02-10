package com.sennalabs.flutter_zoom_sdk;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;

import androidx.annotation.Nullable;

public class VoteWebViewActivity extends Activity {
    private WebView webView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.vote_webview);
        ActionBar actionBar = getActionBar();
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
    public boolean onNavigateUp() {
        finish();
        return true;
    }
}
