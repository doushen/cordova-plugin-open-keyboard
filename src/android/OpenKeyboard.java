package cordova.plugins;

import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * 自定义软键盘
 */
public class OpenKeyboard extends CordovaPlugin {

    public static final String ACTIONS_INIT = "init";
    
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException{
        return actionsRoute(action,args,callbackContext);
    }

    /**
     * actions 路由
     * @param action
     * @param args
     * @param callbackContext
     * @return
     * @throws JSONException
     */
    private boolean actionsRoute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException{
        if (action.equals(ACTIONS_INIT)) {
        	JSONObject options = args.optJSONObject(0);
            init(options,args,callbackContext);
            return true;
        }
        return false;
    }

    /**
    * 键盘初始化
    * @param options  设置
    * @param args
    * @param callbackContext
    */
    private void init(JSONObject options,JSONArray args,CallbackContext callbackContext) throws JSONException {
        Log.i("OpenKeyboard", "键盘初始化...");
        Log.i("OpenKeyboard", "options:"+options);
        PluginResult progressResult = new PluginResult(PluginResult.Status.OK, new JSONObject(
                "{success:" + "\"init success\"" + "}"));
        //progressResult.setKeepCallback(true);
        callbackContext.sendPluginResult(progressResult);
    }

}