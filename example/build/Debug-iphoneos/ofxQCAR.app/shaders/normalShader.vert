varying vec3 norm;
varying vec3 pos;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 normalMatrix;

uniform mat4 mv;
uniform mat4 mp;

attribute vec4 position;
attribute vec4 normal;

void main()
{
//	mat3 normalMatrix = transpose(inverse(modelViewMatrix));

//	norm = normalize(WorldViewInverseTranspose * normal).xyz;
//	norm = norm * .5 + .5;

	//gl_Position = projectionMatrix * modelViewMatrix * position;

	//mat3 m3 = transpose(inverse(mat3(modelViewMatrix)));
	//norm = normalize(m3 * normal);

	 norm =  (normalMatrix * vec4(normal.xyz,0.0)).xyz;
    
     //Scale the positions
     vec4 scalePos = position;

     scalePos.x *= 100.0;
     scalePos.y *= 100.0;
     scalePos.z *= 100.0;

	 vec4 vertPos  =   mv * vec4(position.xyz, 1.0);
     pos = vec3(vertPos.xyz) / vertPos.w;

	 gl_Position = mv * mp * scalePos;
}
