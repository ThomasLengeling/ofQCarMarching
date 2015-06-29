#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"


#include "ofxMarchingCubes.h"

#include "ofxQCAR.h"
#include "Teapot.h"

class ofApp : public ofxQCAR_App {
	
public:
    void setup();
    void update();
    void draw();
    void exit();
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofImage teapotImage;
    ofVec2f touchPoint;
    ofVec2f markerPoint;

    ofImage cameraImage;
    
    
    //ofx Marching Cubes
    void setupMarchingCubes();
    void updateMarchingCubes();
    void drawMarchingCubes();
    
    
    ofxMarchingCubes mc;
    
    ofShader normalShader;
    
    int differentSurfaces;
    
    ofEasyCam camera;
};


