package com.nearhop.realcom;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

/**
 * Created by lakshmana on 01/03/18.
 */

public class NHActivity extends AppCompatActivity {
    boolean active = false;
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    @Override
    public void onResume() {
        active = true;
        super.onResume();
    }
    @Override
    public void onPause() {
        active = false;
        super.onPause();
    }
    @Override
    protected void onStart() {
        // call the superclass method first
        super.onStart();
    }
    @Override
    protected void onStop() {
        // call the superclass method first
        super.onStop();
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
    }
}
