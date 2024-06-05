package io.flutter.plugins;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.MediaPlayer;
import android.util.Log;
import android.view.KeyEvent;


//Package for RFID

import com.ubx.usdk.rfid.RfidManager;
import com.ubx.usdk.RFIDSDKManager;
import com.ubx.usdk.util.QueryMode;
import com.ubx.usdk.rfid.aidl.IRfidCallback;
import android.net.ConnectivityManager;
import com.ubx.usdk.USDKManager;
import com.ubx.usdk.listener.InitListener;
import android.os.Handler;
import android.os.Looper;


import com.ubx.usdk.rfid.RfidManager;

public class RfidManagement implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private RfidManager  mRfidManager;
    public static final String TAG = "usdk";
    public static final String DECODE_DATA_TAG = "com.example.app.DECODE_DATA";
    private ScanCallback callback;
    private Context context;


    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.example/customChannel");
        channel.setMethodCallHandler(this);
        IntentFilter filter = new IntentFilter();
        
   
        initRfid(binding.getApplicationContext());
    
        binding.getApplicationContext().registerReceiver(myDataReceiver, filter);
    }
// 2. Define the startInventory method
private void startInventory() {
    if (mRfidManager != null) {
        mRfidManager.startInventory(0); // replace 0 with the actual session number
    }
}

class ScanCallback implements IRfidCallback {
    @Override
    public void onInventoryTag(String EPC, final String TID, final String strRSSI) {

        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                sendEPCToFlutter(EPC, strRSSI);
            }
        });
    }

    /**
     * 盘存结束回调(Inventory Command Operate End)
     */
    @Override
    public void onInventoryTagEnd() {
        Log.d(TAG, "onInventoryTagEnd()");

    }
}


    private final BroadcastReceiver myDataReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                String action = intent.getAction(); 
                if(action != null){
                    Log.d(TAG, "onReceive()  action = " + action);
                } else{

                    Log.d(TAG, "onReceive()  No action = ");
                }
    
                
               
            } catch (Exception e) {
                Log.e(TAG, "Error in onReceive", e);
            }
        }
    };

  
        
    
    private void initRfid(Context context) {
        RFIDSDKManager.getInstance().init(new InitListener() {
            @Override
            public void onStatus(boolean status) {
                if (status) {
                    Log.d(TAG, "initRfid()  success.");
                    mRfidManager = RFIDSDKManager.getInstance().getRfidManager();
                    callback = new ScanCallback();
                    mRfidManager.registerCallback(callback);
                } else {
                    Log.d(TAG, "initRfid  fail.");
                }
            }
           
        });
        
    }

    private void sendEPCToFlutter(String epc,String rssi) {
        Log.d(TAG, "sendEPCToFlutter()  epc = " + epc + "  rssi = " + rssi);
        Map<String, String> tagData = new HashMap<>();
        tagData.put("epc", epc);
        tagData.put("rssi", rssi);
        channel.invokeMethod("onTagScanned", tagData);
    }

    private void sendConnection(boolean status) {
        channel.invokeMethod("Connection", status);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
       
        switch (call.method) {
            case "getServiceVersion":
               
                result.success("asdasd");
                break;
                case "startInventory":
              
                    result.success(mRfidManager.startInventory(0));
                    break;
                    case "stopInventory":
                    result.success(mRfidManager.stopInventory());   
                    break;
            case "Scanned":
            RFIDSDKManager.getInstance().enableScanHead(Boolean.parseBoolean(call.argument("statusTrg").toString()));
            result.success("Scanned" + call.argument("statusTrg"));
            break;

            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        if(mRfidManager != null){
            mRfidManager.release();
            mRfidManager = null;
            Log.d(TAG,"Release RFID");
        }
       
        channel.setMethodCallHandler(null);
    }

}