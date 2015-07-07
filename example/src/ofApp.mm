#include "ofApp.h"

static const string kLicenseKey = "AfJ6d4//////AAAAAck2JyVaKEJarsb9283lT4EiMz7jNMKKEPuFlDhX9shBx1A41N05tPNEMHb4IMvsx3DNpjbyXLrUQJdJcwS2IzV4NdmwY7R8CkxZFeVKEotcSjh296otcRMmZPAYWRQAFL7f4ljQLMSVjvDFZRLf9/X5uIR+wNNTqK47d1NpPhDBv2usiT0Z8SxSej5Dn919ue2p8o8QGk/KThAFPVCwIQxigXauDlECHFB0EHvoNNatMVsjyMC3hKU/btXbCFMa2wL5ZM/nQgVeqveMv5eOygzCCLkDIMC2R8QRQzqAvH4h2I0YBJ0CMxD98AP45wEwxLOOLMRFdIOi2THxpVhWHSHiU/b6XSX96FHY/0eM3aul";

void ofApp::setupMarchingCubes()
{
    
    //marching cubes
   // glEnable(GL_DEPTH_TEST);
    
    differentSurfaces = 0;
    mc.setup();
    
    mc.setResolution(16, 16, 16); //resolution
    mc.scale.set( 500, 500, 250 ); //scalar
    
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
   // float elapsedTime = ofGetElapsedTimef();
  //  ofSetWindowTitle( ofToString( ofGetFrameRate() ) );
    
    
    glEnable(GL_DEPTH_TEST);
   glEnable(GL_CULL_FACE);
    
    camera.begin();
    
    //draw the mesh
    
    ofPushMatrix();
    ofPushView();
    
    ofScale(250, 250, 250);
    
   ofMatrix4x4 matP = ofGetCurrentMatrix(OF_MATRIX_PROJECTION);
    ofMatrix4x4 matMV = ofGetCurrentMatrix(OF_MATRIX_MODELVIEW);
    
    ofMatrix4x4 normalMatrix = ofMatrix4x4::getTransposedOf(matMV.getInverse());
    
    normalShader.begin();
    normalShader.setUniformMatrix4f("mv", matP);
    normalShader.setUniformMatrix4f("mp", matMV);
    normalShader.setUniformMatrix4f("normalMatrix", normalMatrix);
    

    mc.draw();
  //  mc.drawGrid();
    ofPopMatrix();
    ofPopView();
    
     normalShader.end();
    
    camera.end();
    
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    //draw the mesh
   // normalShader.begin();
    
   // normalShader.end();
    
}

//--------------------------------------------------------------
void ofApp::setup(){
	ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    teapotImage.loadImage("qcar_assets/TextureTeapotBrass.png");
    teapotImage.mirror(true, false);  //-- flip texture vertically since the texture coords are set that way on the teapot.
    
    touchPoint.x = touchPoint.y = -1;

    ofxQCAR & QCAR = *ofxQCAR::getInstance();
    QCAR.setLicenseKey(kLicenseKey); // ADD YOUR APPLICATION LICENSE KEY HERE.
    QCAR.addMarkerDataPath("qcar_assets/Qualcomm.xml");
    QCAR.autoFocusOn();
    QCAR.setCameraPixelsFlag(true);
    QCAR.setup();
    
    setupMarchingCubes();
}

//--------------------------------------------------------------
void ofApp::update(){
    ofxQCAR::getInstance()->update();
    
    updateMarchingCubes();
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    
   // drawMarchingCubes();
    
    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->draw();
    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if(qcar->hasFoundMarker()) {

        ofDisableDepthTest();
        //ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        ofSetLineWidth(3);
        
        bool bInside = false;
        if(bPressed) {
            vector<ofPoint> markerPoly;
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)0));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)1));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)2));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)3));
            bInside = ofInsidePoly(touchPoint, markerPoly);
        }
        
        if(bInside == true) {
            ofSetColor(ofColor(255, 0, 255, 150));
        } else {
            ofSetColor(ofColor(255, 0, 255, 50));
        }
        
        qcar->drawMarkerRect();
        
        ofSetColor(ofColor::yellow);
        qcar->drawMarkerBounds();
        ofSetColor(ofColor::cyan);
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        ofEnableDepthTest();
        ofEnableNormalizedTexCoords();
        
        /*qcar->begin();
        teapotImage.getTextureReference().bind();
        ofSetColor(255, 230);
        ofScale(3, 3, 3);
        
        ofDrawTeapot();
       
        
        ofSetColor(255);
        teapotImage.getTextureReference().unbind();
        qcar->end();
         */
        
        ofDisableNormalizedTexCoords();
    
        qcar->begin();
        drawMarchingCubes();
        qcar->end();
        
        qcar->begin();
        ofNoFill();
        ofSetColor(255, 0, 0, 200);
        ofSetLineWidth(6);
        float radius = 20;
        ofPushMatrix();
        ofTranslate(markerPoint.x, markerPoint.y);
        //drawMarchingCubes();
        ofCircle(0, 0, radius);
        ofLine(-radius, 0, radius, 0);
        ofLine(0, -radius, 0, radius);
        ofPopMatrix();
        ofFill();
        ofSetColor(255);
        ofSetLineWidth(1);
        qcar->end();
    }
    
    ofDisableDepthTest();
    
    /**
     *  access to camera pixels.
     */
    int cameraW = qcar->getCameraWidth();
    int cameraH = qcar->getCameraHeight();
    unsigned char * cameraPixels = qcar->getCameraPixels();
    if(cameraW > 0 && cameraH > 0 && cameraPixels != NULL) {
        if(cameraImage.isAllocated() == false ) {
            cameraImage.allocate(cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        }
        cameraImage.setFromPixels(cameraPixels, cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_PORTRAIT) {
            cameraImage.rotate90(1);
        } else if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_LANDSCAPE) {
            cameraImage.mirror(true, true);
        }

        cameraW = cameraImage.getWidth() * 0.5;
        cameraH = cameraImage.getHeight() * 0.5;
        int cameraX = 0;
        int cameraY = ofGetHeight() - cameraH;
        cameraImage.draw(cameraX, cameraY, cameraW, cameraH);
        
        ofPushStyle();
        ofSetColor(ofColor::white);
        ofNoFill();
        ofSetLineWidth(3);
        ofRect(cameraX, cameraY, cameraW, cameraH);
        ofPopStyle();
    }
    
    if(bPressed) {
        ofSetColor(ofColor::red);
        ofDrawBitmapString("touch x = " + ofToString((int)touchPoint.x), ofGetWidth() - 140, ofGetHeight() - 40);
        ofDrawBitmapString("touch y = " + ofToString((int)touchPoint.y), ofGetWidth() - 140, ofGetHeight() - 20);
        ofSetColor(ofColor::white);
        
        
    }
    
 //   ofPushMatrix();
  //  ofTranslate(markerPoint.x, markerPoint.y);
  //  drawMarchingCubes();
  //  ofPopMatrix();
    

}

//--------------------------------------------------------------
void ofApp::exit(){
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
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

