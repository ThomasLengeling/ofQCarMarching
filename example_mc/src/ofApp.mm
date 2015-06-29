#include "ofApp.h"

void ofApp::setupMarchingCubes()
{
    
    //marching cubes
    glEnable(GL_DEPTH_TEST);
    
    differentSurfaces = 0;
    mc.setup();
    mc.setResolution(32,16,32);
    mc.scale.set( 500, 250, 500 );
    
    mc.setSmoothing( false );
    
    normalShader.load("shaders/normalShader.vert, shaders/normalShader.frag");
}

void ofApp::updateMarchingCubes()
{
    if(differentSurfaces == 0){
        //NOISE
        float noiseStep = ofGetElapsedTimef() * .5;
        float noiseScale = .06;
        float noiseScale2 = noiseScale * 2.;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){
                    //noise
                    float nVal = ofNoise(float(i)*noiseScale, float(j)*noiseScale, float(k)*noiseScale + noiseStep);
                    if(nVal > 0.)	nVal *= ofNoise(float(i)*noiseScale2, float(j)*noiseScale2, float(k)*noiseScale2 + noiseStep);
                    mc.setIsoValue( i, j, k, nVal );
                }
            }
        }
    }
    else if(differentSurfaces == 1){
        //SPHERES
        ofVec3f step = ofVec3f(3./mc.resX, 1.5/mc.resY, 3./mc.resZ) * PI;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){;
                    float val = sin(float(i)*step.x) * sin(float(j+ofGetElapsedTimef())*step.y) * sin(float(k+ofGetElapsedTimef())*step.z);
                    val *= val;
                    mc.setIsoValue( i, j, k, val );
                }
            }
        }
    }
    else if(differentSurfaces == 2){
        //SIN
        float sinScale = .5;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){
                    float val = sin(float(i)*sinScale) + cos(float(j)*sinScale) + sin(float(k)*sinScale + ofGetElapsedTimef());
                    mc.setIsoValue( i, j, k, val * val );
                }
            }
        }
    }
    
    //update the mesh
    mc.update();
    //	mc.update(threshold);
}
void ofApp::drawMarchingCubes()
{
    float elapsedTime = ofGetElapsedTimef();
    ofSetWindowTitle( ofToString( ofGetFrameRate() ) );
    
    camera.begin();
    
    mc.draw();
    
    //draw the mesh
   // normalShader.begin();
    
   // normalShader.end();
    
    
    camera.end();
}

//--------------------------------------------------------------
void ofApp::setup()
{
	ofBackground(0);
    
    
    touchPoint.x = touchPoint.y = -1;
    
    setupMarchingCubes();
}

//--------------------------------------------------------------
void ofApp::update()
{
    
    updateMarchingCubes();
}

//--------------------------------------------------------------
void ofApp::draw()
{
    

    drawMarchingCubes();

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

