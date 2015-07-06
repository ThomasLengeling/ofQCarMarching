#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

varying vec3 norm;
varying vec3 pos;

//const vec3 cLight = normalize(vec3(.5, .5, 1.));

int mode = 2;

const vec3 lightPos = vec3(0.0, 0.0, 0.0);
const vec3 ambientColor = vec3(0.0, 0.0, 0.0);
const vec3 diffuseColor = vec3(0.5, 0.5, 0.5);
const vec3 specColor = vec3(0.8, 0.8, 0.8);
const float shininess = 8.0;
const float screenGamma = 1.5; // Assume the monitor is calibrated to the sRGB color space


void main(void)
{
  vec3 normal =  normalize(norm);
  //vec4 light  =  vec4(normal * 0.5 + vec3(0.5,0.5,0.5), 1.0);
	//gl_FragColor = light;


	vec3 lightDir = normalize(lightPos - pos);

	float lambertian = max(dot(lightDir, normal), 0.0);
	float specular = 0.0;

	if(lambertian > 0.0) {

		vec3 viewDir = normalize(-pos);

		// this is blinn phong
		vec3 halfDir = normalize(lightDir + viewDir);
		float specAngle = max(dot(halfDir, normal), 0.0);
		specular = pow(specAngle, shininess);

		// this is phong (for comparison)
		if(mode == 2) {
			vec3 reflectDir = reflect(-lightDir, normal);
			specAngle = max(dot(reflectDir, viewDir), 0.0);
			// note that the exponent is different here
			specular = pow(specAngle, shininess/4.0);
		}
	}
	vec3 colorLinear = ambientColor +
									lambertian * diffuseColor +
									specular * specColor;

	// apply gamma correction
	vec3 colorGammaCorrected = pow(colorLinear, vec3(1.0/screenGamma));
	
	// use the gamma corrected color in the fragment
	gl_FragColor = vec4(colorGammaCorrected, 0.8);
}
