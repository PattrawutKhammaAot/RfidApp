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
import android.os.Build;
import com.ubx.usdk.rfid.RfidManager;
import android.device.ScanManager;

//Sound
import io.flutter.plugins.SoundTool;

public class RfidManagement implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private RfidManager mRfidManager;
    private RfidManager mRfidManager1;
    private ScanManager mScanManager;
    public static final String TAG = "usdk";
    public static final String DECODE_DATA_TAG = "com.example.app.DECODE_DATA";
    private ScanCallback callback;
    private Context context;
    private FlutterPluginBinding bindingObject;

    boolean isASCII = true;
    int lengthOfASCII = 10;
    private SoundTool soundTool;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        bindingObject = binding;
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.example/customChannel");
        channel.setMethodCallHandler(this);
        IntentFilter filter = new IntentFilter();
        
        mScanManager = new ScanManager();
        initRfid(binding.getApplicationContext());

    }

    private void initRfid(Context context) {
        try {
            RFIDSDKManager.getInstance().init(new InitListener() {
                @Override
                public void onStatus(boolean status) {
                    if (status) {
                        mScanManager = new ScanManager();
                        Log.d(TAG, "initRfid()  success.");
                        mRfidManager = RFIDSDKManager.getInstance().getRfidManager();
                        callback = new ScanCallback();
                       
                        mRfidManager.registerCallback(callback);
                        soundTool = SoundTool.getInstance(context);

                    } else {
                        Log.d(TAG, "initRfid  fail.");
                    }
                }

            });

        } catch (Exception e) {

            Log.e(TAG, "Error in initRfid", e);

        }

    }

    class ScanCallback implements IRfidCallback {
        @Override
        public void onInventoryTag(String EPC, final String TID, final String strRSSI) {

            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    if (isASCII) {
                        final String asciiEPC = hexToAscii(EPC);
                        if (asciiEPC != null && !asciiEPC.isEmpty()) {
                            String extractedEPC = asciiEPC.substring(0, Math.min(asciiEPC.length(), lengthOfASCII));
                            sendEPCToFlutter(extractedEPC, strRSSI, isASCII);
                        }
                    } else {
                        sendEPCToFlutter(EPC, strRSSI, isASCII);

                    }

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
                if (action != null) {
                    Log.d(TAG, "onReceive()  action = " + action);
                } else {

                    Log.d(TAG, "onReceive()  No action = ");
                }

            } catch (Exception e) {
                Log.e(TAG, "Error in onReceive", e);
            }
        }
    };

    private void sendEPCToFlutter(String epc, String rssi, boolean isASCII) {
        Log.d(TAG, "sendEPCToFlutter()  epc = " + epc + "  rssi = " + rssi + " isASCII = " + isASCII);
        Map<String, String> tagData = new HashMap<>();
        tagData.put("epc", epc.trim());
        tagData.put("rssi", rssi);
        channel.invokeMethod("onTagScanned", tagData);
        
    }

    private void sendConnection(boolean status) {
        channel.invokeMethod("Connection", status);
    }

    private String hexToAscii(String hexStr) {
        StringBuilder output = new StringBuilder();
        for (int i = 0; i < hexStr.length(); i += 2) {
            String str = hexStr.substring(i, i + 2);
            int decimalValue = Integer.parseInt(str, 16);

            if (decimalValue >= 32 && decimalValue <= 126) {
                output.append((char) decimalValue);
            }
        }
        return output.toString();
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
                RFIDSDKManager.getInstance()
                        .enableScanHead(Boolean.parseBoolean(call.argument("statusTrg").toString()));
                result.success("Scanned" + call.argument("statusTrg"));
                break;
            case "GetPower":
                result.success(mRfidManager.getOutputPower());
                break;
            case "SetPower":
            try {
                int power = Integer.parseInt(call.argument("power").toString());
                Log.d(TAG, "Release RFID " + power);
                int isSuccess = mRfidManager.setOutputPower(power);
                if (isSuccess == 0) {
                    result.success("Power set to " + power);
                } else {
                    initRfid(bindingObject.getApplicationContext());
                    int isTrySuccess = mRfidManager.setOutputPower(power);
                    if(isTrySuccess == 0){
                        result.success("try Power set to " + power);
                    }else{
                        result.error("TRY_ERROR", "Error setting power after retry", null);
                    }
                }
            } catch (Exception e) {
                Log.e(TAG, "Exception setting power", e);
                result.error("EXCEPTION", "Exception setting power: " + e.getMessage(), null);
            }
                break;
            case "SetASCII":
                isASCII = Boolean.parseBoolean(call.argument("isASCII").toString());
                result.success("Success! ASCII set to " + isASCII);
                break;
            case "GetASCII":
                result.success(isASCII);
                break;
            case "GetLengthASCII":
                result.success(lengthOfASCII);
                break;
            case "SetLengthASCII":
                lengthOfASCII = Integer.parseInt(call.argument("length").toString());
                result.success("Success! Length set to " + lengthOfASCII);
                break;

            case "OpenScanner":
                mScanManager.openScanner();
                soundTool.playBeep();
                result.success("Scanner opened");
                break;
            case "CloseScanner":
                mScanManager.closeScanner();
                soundTool.playBeep();
                result.success("Scanner closed");
                break;
            case "CheckScanner":
                try{
                result.success(mScanManager.getScannerState());
                }catch(Exception e){
                    Log.e(TAG, "Error in CheckScanner", e);
                    result.success(e);
                }
            break;
              case "getTriggerLockState":
                try{
                result.success(mScanManager.getTriggerLockState());
                }catch(Exception e){
                    Log.e(TAG, "Error in CheckScanner", e);
                    result.success(e);
                }
            break;
            case "initScanner":
                try{
               initRfid(bindingObject.getApplicationContext());
                result.success("Scanner initialized");
                }catch(Exception e){
                    Log.e(TAG, "Error in initScanner", e);
                    result.success(e);
                }
            break;
            case "usedSound":
                if(soundTool != null){
                    soundTool.playBeep();
                }
            break;
            
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        if (mRfidManager != null) {
            mRfidManager.release();
            mRfidManager = null;
       
            mScanManager = null;
            Log.d(TAG, "Release RFID");
        }

        channel.setMethodCallHandler(null);
    }

}
