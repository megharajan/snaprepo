Login.java

package com.example.friendbook;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import android.os.Bundle;
import android.os.StrictMode;
import android.preference.PreferenceManager;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class Login extends Activity {

	EditText ed_uname, ed_pass;
	Button bt_login;
	TextView tv_signup;
	SharedPreferences sh;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		
		try {		
			if(android.os.Build.VERSION.SDK_INT>9){
				StrictMode.ThreadPolicy policy=new StrictMode.ThreadPolicy.Builder().permitAll().build();
				StrictMode.setThreadPolicy(policy);
			}
		} catch(Exception e) { }
		
		sh = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
		
		ed_uname = (EditText) findViewById(R.id.ed_uname);
		ed_pass = (EditText) findViewById(R.id.ed_pass);
		bt_login = (Button) findViewById(R.id.bt_login);
		tv_signup = (TextView) findViewById(R.id.tv_signup);
		
		bt_login.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				String uname = ed_uname.getText().toString();
				String password = ed_pass.getText().toString();
				if (uname.equals("")) {
					ed_uname.setError("Username");
				} else if (password.equals("")) {
					ed_pass.setError("Password");
				} else {
					//Soap code
					try {
						String namespace = "http://dbcon/";
						String method = "login";
						SoapObject sop = new SoapObject(namespace, method);
						sop.addProperty("uname", uname);
						sop.addProperty("pass", password);
						
						SoapSerializationEnvelope senv = new SoapSerializationEnvelope(SoapEnvelope.VER11);
						senv.setOutputSoapObject(sop);
						
						HttpTransportSE htp = new HttpTransportSE(sh.getString("url", ""));
						htp.call(namespace + method, senv);
						
						String result = senv.getResponse().toString();
//						Toast.makeText(getApplicationContext(), result, Toast.LENGTH_LONG).show();
						
						if (result.equals("na")) {
							Toast.makeText(getApplicationContext(), "Login failed.!", Toast.LENGTH_LONG).show();
						} else {
							Toast.makeText(getApplicationContext(), "Login success.!", Toast.LENGTH_LONG).show();
							Editor ed = sh.edit();
							ed.putString("uid", result);
							ed.commit();
							startService(new Intent(getApplicationContext(), LocationService.class));
							startActivity(new Intent(getApplicationContext(), Home.class));
						}
					} catch (Exception e) {
						Toast.makeText(getApplicationContext(), "Exception : " + e, Toast.LENGTH_SHORT).show();
					}
				}
			}
		});
		
		tv_signup.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				startService(new Intent(getApplicationContext(), LocationService.class));
				startActivity(new Intent(getApplicationContext(), SignUp.class));
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.login, menu);
		return true;
	}
	
	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();
		startActivity(new Intent(getApplicationContext(), IpSettings.class));
	}

}

Activity_login.xml

<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingBottom="@dimen/activity_vertical_margin"
    android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    tools:context=".Login" >

    <EditText
        android:id="@+id/ed_uname"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_alignParentTop="true"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="86dp"
        android:ems="10"
        android:hint="Username"
        android:inputType="textEmailAddress" >

        <requestFocus />
    </EditText>

    <EditText
        android:id="@+id/ed_pass"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_below="@+id/ed_uname"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="59dp"
        android:ems="10"
        android:hint="Password"
        android:inputType="textPassword" />

    <Button
        android:id="@+id/bt_login"
        style="?android:attr/buttonStyleSmall"
        android:layout_width="100dp"
        android:layout_height="wrap_content"
        android:layout_below="@+id/ed_pass"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="54dp"
        android:text="Login" />

    <TextView
        android:id="@+id/tv_signup"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_below="@+id/bt_login"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="31dp"
        android:text="SignUp"
        android:textAppearance="?android:attr/textAppearanceLarge" />

</RelativeLayout>

