    package com.example.rfid

    import androidx.annotation.NonNull
    import io.flutter.embedding.android.FlutterActivity
    import io.flutter.embedding.engine.FlutterEngine
    import io.flutter.plugin.common.MethodChannel
    import android.content.Context
    import android.content.ContextWrapper
    import android.content.Intent
    import android.content.IntentFilter
    import android.os.BatteryManager
    import android.os.Build.VERSION
    import android.os.Build.VERSION_CODES
    import android.os.Build

    import android.app.AlertDialog;
    import android.app.ProgressDialog;
    import android.content.BroadcastReceiver;
 
    import android.content.DialogInterface;

    import android.content.SharedPreferences;
    import android.content.SharedPreferences.Editor;
    import android.content.DialogInterface.OnClickListener;
   
    import android.graphics.Bitmap;
    import android.graphics.BitmapFactory;
    import android.os.AsyncTask;
    import android.os.Handler;
    import android.os.Message;
    import android.preference.EditTextPreference;
    import android.preference.ListPreference;
    import android.preference.Preference;
    import android.preference.PreferenceFragment;
    import android.preference.PreferenceManager;
    import android.preference.PreferenceScreen;
    import android.preference.SwitchPreference;
    import android.app.FragmentManager;
    import android.app.FragmentTransaction;

    import android.os.Bundle;

    import android.preference.CheckBoxPreference;
    import android.view.KeyEvent;
    import android.view.Menu;
    import android.view.MenuItem;
    import android.view.MotionEvent;
    import android.view.View;
    import android.view.Window;
    import android.view.WindowManager;
    import android.widget.Button;
    import android.widget.EditText;
    import android.widget.FrameLayout;
    import android.widget.ImageView;
    import android.widget.LinearLayout;
    import android.widget.Toast;

    import java.util.HashMap;
    import java.util.Map;
    //import android.device.scanner.configuration.Constants;
    //import android.device.scanner.configuration.PropertyID;
    //import android.device.scanner.configuration.Symbology;
    //import android.device.scanner.configuration.Triggering;
    //import android.device.ScanManager;
    //import android.support.annotation.Nullable;
    //import android.support.v7.app.AppCompatActivity;
    class MainActivity: FlutterActivity() {
        private val CHANNEL = "myscanner_rfid"
        private val TAG = "ScanManagerDemo"
        private val DEBUG = true
        //private val ACTION_DECODE = ScanManager.ACTION_DECODE
        private val ACTION_DECODE_IMAGE_REQUEST = "action.scanner_capture_image"
        private val ACTION_CAPTURE_IMAGE = "scanner_capture_image_result"
        //private val BARCODE_STRING_TAG = ScanManager.BARCODE_STRING_TAG
        //private val BARCODE_TYPE_TAG = ScanManager.BARCODE_TYPE_TAG
        //private val BARCODE_LENGTH_TAG = ScanManager.BARCODE_LENGTH_TAG
        //private val DECODE_DATA_TAG = ScanManager.DECODE_DATA_TAG
        private val DECODE_ENABLE = "decode_enable"
        private val DECODE_TRIGGER_MODE = "decode_trigger_mode"
        private val DECODE_TRIGGER_MODE_HOST = "HOST"
        private val DECODE_TRIGGER_MODE_CONTINUOUS = "CONTINUOUS"
        private val DECODE_TRIGGER_MODE_PAUSE = "PAUSE"
        private var DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_HOST
        private val DECODE_OUTPUT_MODE_INTENT = 0
        private val DECODE_OUTPUT_MODE_FOCUS = 1
        private var DECODE_OUTPUT_MODE_CURRENT = DECODE_OUTPUT_MODE_FOCUS
        private val DECODE_OUTPUT_MODE = "decode_output_mode"
        private val DECODE_CAPTURE_IMAGE_KEY = "bitmapBytes"
        private val DECODE_CAPTURE_IMAGE_SHOW = "scan_capture_image"
        private var showScanResult: EditText? = null
        private var mScan: Button? = null
        private var mHome: LinearLayout? = null
        private var mFlagment: FrameLayout? = null
        private var settings: MenuItem? = null
        private var mScanImage: ImageView? = null
        //private var mScanManager: ScanManager? = null
        private var mScanEnable = true
        private var mScanSettingsView = false
        private var mScanCaptureImageShow = false
        private var mScanBarcodeSettingsMenuBarcodeList = false
        private var mScanBarcodeSettingsMenuBarcode = false
        private var mScanSettingsMenuBarcodeList: FrameLayout? = null
        private var mScanSettingsMenuBarcode: FrameLayout? = null
        //private var mScanSettingsBarcode: ScanSettingsBarcode? = null
        //private var mSettingsBarcodeList: SettingsBarcodeList? = null
        //private val mBarcodeMap = mutableMapOf<String, BarcodeHolder>()
        private val MSG_SHOW_SCAN_RESULT = 1
        private val MSG_SHOW_SCAN_IMAGE = 2
        //private var mScanSettingsFragment = ScanSettingsFragment()
        private val SCAN_KEYCODE = intArrayOf(520, 521, 522, 523)
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
                if (call.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()

                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        }

        private fun getBatteryLevel(): Int {
            val batteryLevel: Int
            if (Build.VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
                val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            } else {
                val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            }

            return batteryLevel
        }
    }