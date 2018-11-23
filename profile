MyProfile.java

package com.example.friendbook;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import com.squareup.picasso.Picasso;

import android.os.Bundle;
import android.preference.PreferenceManager;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class MyProfile extends Activity {
	
	SharedPreferences sh;
	ImageView iv;
	TextView tv;
	Button bt;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_my_profile);
		
		sh = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
		iv = (ImageView) findViewById(R.id.iv_dp_myprofile);
		tv = (TextView) findViewById(R.id.tv_my_details);
		bt = (Button) findViewById(R.id.bt_edit_profile);
		
		bt.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				startActivity(new Intent(getApplicationContext(), UpdateProfile.class));
			}
		});
		
		try {
			String namespace = "http://dbcon/";
			String method = "getMyDetails";
			SoapObject sop = new SoapObject(namespace, method);
			sop.addProperty("uid", sh.getString("uid", "0"));
			
			SoapSerializationEnvelope senv = new SoapSerializationEnvelope(SoapEnvelope.VER11);
			senv.setOutputSoapObject(sop);
			
			HttpTransportSE htp = new HttpTransportSE(sh.getString("url", ""));
			htp.call(namespace + method, senv);
			
			String result = senv.getResponse().toString();
//			Toast.makeText(getApplicationContext(), result, Toast.LENGTH_LONG).show();
			
			if (result.equals("na")) {
				Toast.makeText(getApplicationContext(), "Something went rong.!", Toast.LENGTH_LONG).show();
			} else {
				String[] temp = result.split("\\#");
				if (temp.length > 0) {
					tv.setText(temp[0] + " " + temp[1] + "\n" + temp[2] + "\n" + temp[3] + "\n" + temp[4] + "\n" + temp[5] + "\n");
					
					String path = "http://" + sh.getString("ip", "") + "/friend/temp_friend_suggestion/img/dp/" + temp[6];
					Picasso.with(getApplicationContext()).load(path).placeholder(R.drawable.people).error(R.drawable.people).into(iv);
				}
			}
		} catch (Exception e) {
			Toast.makeText(getApplicationContext(), "Exception : " + e, Toast.LENGTH_SHORT).show();
		}
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		startActivity(new Intent(getApplicationContext(), Home.class));
	}
}

activity_my_profile.xml

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingBottom="@dimen/activity_vertical_margin"
    android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:orientation="vertical"
    tools:context=".MyProfile" >

    <TextView
        android:id="@+id/textView1"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:gravity="center"
        android:text="My profile"
        android:textSize="25dp" />
    
    <TableRow
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="15dp"
        android:gravity="center" >

	    <ImageView
	        android:id="@+id/iv_dp_myprofile"
	        android:layout_width="180dp"
	        android:layout_height="150dp"
	        android:layout_centerHorizontal="true"
	        android:src="@drawable/people" />
    </TableRow>

    <TableRow
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="10dp"
        android:gravity="center" >
        
        <TextView
	        android:id="@+id/tv_my_details"
	        android:layout_width="wrap_content"
	        android:layout_height="wrap_content"
	        android:layout_below="@+id/iv_dp_myprofile"
	        android:text="Details"
	        android:textAppearance="?android:attr/textAppearanceMedium" />
    </TableRow>
    
    <TableRow
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="10dp"
        android:gravity="center" >
        
        <Button
            android:id="@+id/bt_edit_profile"
            android:layout_width="120dp"
            android:layout_height="wrap_content"
            android:text="Edit" />
    </TableRow>

</LinearLayout>
