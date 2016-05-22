package redealumni.agoravai;

import com.loopj.android.http.*;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.os.StrictMode;

import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;


import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.entity.mime.content.ContentBody;
import cz.msebera.android.httpclient.entity.mime.content.InputStreamBody;


public class MainActivity extends AppCompatActivity {
    private static final int CAMERA_REQUEST = 1888;
    private ImageView imageView;
    private TextView txtView;
    private String fileName = Environment.getExternalStorageDirectory() + File.separator + "temp.png";
    String mCurrentPhotoPath;
    static final int REQUEST_TAKE_PHOTO = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.imageView = (ImageView) this.findViewById(R.id.imageView1);
        this.txtView = (TextView) findViewById(R.id.textView2);

    }

    //*
    public void captureImage(View view) {
        //Intent cameraIntent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
        //startActivityForResult(cameraIntent, CAMERA_REQUEST);

        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(cameraIntent, CAMERA_REQUEST);
    }//*/
    /*******************************************
     *
     * na vdd essa porra e so o thumbnail
     * *****************************************/

    public static long getFolderSize(File f) {
        long size = 0;
        if (f.isDirectory()) {
            for (File file : f.listFiles()) {
                size += getFolderSize(file);
            }
        } else {
            size=f.length();
        }
        return size;
    }



    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == CAMERA_REQUEST && resultCode == RESULT_OK) {
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            //Bitmap photo = (Bitmap) data.get;
            imageView.setImageBitmap(photo);

            ///*
            FileOutputStream out = null;
            try {
                out = new FileOutputStream(fileName);
                photo.compress(Bitmap.CompressFormat.PNG, 100, out); // bmp is your Bitmap instance
                // PNG is a lossless format, the compression factor (100) is ignored
                out.flush();
                out.close();
            } catch (Exception e) {
                txtView.setText("FAIL: "+e);
            }

            txtView.setText("THUMB IMAGE SAVED TO : "+ fileName);
        }

        if (requestCode == REQUEST_TAKE_PHOTO && resultCode == RESULT_OK)
        {
            String value=null;
            long Filesize=getFolderSize(new File(fileName))/1024;//call function and convert bytes into Kb
            if(Filesize>=1024)
                value=Filesize/1024+" Mb";
            else
                value=Filesize+" Kb";

            txtView.setText("FULL IMAGE SAVED TO: "+ fileName + " of size " +value);


            Bitmap myBitmap = BitmapFactory.decodeFile(fileName);
            imageView.setImageBitmap(myBitmap);
        }
    }




    /*******************************************
     *
     * ....
     *******************************************/
    private File createImageFile() throws IOException {
        // Create an image file name
        //String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        //String imageFileName = "JPEG_" + timeStamp + "_";

        String imageFileName= "mondai";

        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        mCurrentPhotoPath = image.getAbsolutePath();


        return image;
    }



    public void takePicture(View view)
    {

        txtView.setText("pow");
        ///*
        try {
            Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            File photoFile = null;
            //photoFile = createImageFile();

            photoFile = new File(fileName);


            txtView.setText("WILL SAVE IMAGE ON: "+ fileName);


            // Continue only if the File was successfully created
            if (photoFile != null) {
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile));
                startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO);
            }
        } catch (Exception ex) {
            // Error occurred while creating the File
            txtView.setText(ex.toString());
        }//*/

    } // public void takePicture(View view)







    public void enableStrictMode()
    {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
    }



    /*******************************************
     * FUNCIONAAAA
     *
     *******************************************/
    public void sendImage(View view) {

        txtView.setText("...");
        enableStrictMode(); //acochambracao master

        try {
            AsyncHttpClient client = new AsyncHttpClient();
            RequestParams params = new RequestParams();

            //File myFile = new File(mCurrentPhotoPath);
            //File myFile = new File(fileName);
            String jpegFileName = Environment.getExternalStorageDirectory() + File.separator + "temp.jpg";
            File jpegFile = new File(jpegFileName);
            Bitmap bmp = BitmapFactory.decodeFile(fileName);
            FileOutputStream fos = new FileOutputStream(jpegFile);
            bmp.compress(Bitmap.CompressFormat.JPEG, 70, fos);
            fos.flush();
            fos.close();



            String value=null;
            long Filesize=getFolderSize(jpegFile)/1024;//call function and convert bytes into Kb
            if(Filesize>=1024)
                value=Filesize/1024+" Mb";
            else
                value=Filesize+" Kb";

            txtView.setText("Sending compressed image of size " +value + "...");

            params.put("data", jpegFile);
            client.post("http://agoravai.querobolsa.space/uploads/file", params,new AsyncHttpResponseHandler()
            {
                @Override
                public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                    txtView.setText("WIN: " + new String(responseBody));
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error) {
                   txtView.setText("FAIL: " + new String(responseBody));
                }
            }
            );

        }  catch (Exception ex) {
            //Exception handling
            txtView.setText("FAIL: " + ex);
        }


    } // public void sendImage(View view) {


}
