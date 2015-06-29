#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

varying vec3 norm;

void main(void)
{
	gl_FragColor = vec4( norm, 1.);
}

