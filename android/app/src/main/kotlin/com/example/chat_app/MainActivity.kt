package com.example.chat_app

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.View
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CODE_DRAW_OVER_OTHER_APP_PERMISSION = 2084
    private val CHANNEL = "chat_app.flutter.dev/chatBubble"
    ///Dòng đầu tiên khai báo hằng số CODE_DRAW_OVER_OTHER_APP_PERMISSION là một số nguyên có giá trị bằng 2084. Hằng số này có thể được sử dụng làm mã yêu cầu để xin quyền hiển thị nội dung của ứng dụng lên trên các ứng dụng khác trên hệ điều hành Android.
    ///Dòng thứ hai khai báo hằng số CHANNEL là một chuỗi có giá trị bằng "chat_app.flutter.dev/chatBubble". Hằng số này có thể được sử dụng để định danh một kênh thông báo trong ứng dụng Android, là cách để nhóm và phân loại các thông báo dựa trên tính quan trọng và nội dung của chúng.

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "showBubbleChat") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {

                    //If the draw over permission is not available open the settings screen
                    //to grant the permission.
                    val intent = Intent(
                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:$packageName")
                    )
                    startActivityForResult(intent, CODE_DRAW_OVER_OTHER_APP_PERMISSION)
                }
                else {
                    startService(Intent(this@MainActivity, ChatHeadService::class.java))
                    finish()
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CODE_DRAW_OVER_OTHER_APP_PERMISSION) {

            //Check if the permission is granted or not.
            // Settings activity never returns proper value so instead check with following method
            if (Settings.canDrawOverlays(this)) {
//                initializeView()
            } else { //Permission is not available
                Toast.makeText(
                    this,
                    "Draw over other app permission not available. Closing the application",
                    Toast.LENGTH_SHORT
                ).show()
                finish()
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }
}
