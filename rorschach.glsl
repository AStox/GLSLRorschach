#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(1233.1,311.7)),dot(p,vec2(219.5,143.3))))*43258.5253);
}

float noise(vec2 st)
{
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);

    float m_dist = 0.;
    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            // Neighbor place in the grid
            vec2 neighbor = vec2(float(x),float(y));

            // Random position from current + neighbor place in the grid
            vec2 point = random2(i_st + neighbor);

			// Animate the point
            point = 0.5 + 0.5*sin(u_time*0.5 + 8.211*point);

			// Vector between the pixel and the point
            vec2 diff = neighbor + point - f_st;

            // Distance to the point
            float dist = smoothstep(0.,1.,length(diff));

            m_dist += (dist);
            // Keep the closer distance
            // m_dist = min(m_dist, dist);
        }
    }
    st = gl_FragCoord.xy/u_resolution.xy;
    float cdist = smoothstep(0.1,0.9,length(st - vec2(0.5)))*5.;

    return (m_dist+cdist-6.3)/2.;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    vec3 color = vec3(.0);
    // Scale
    float scale = 11.;
	float cdist = smoothstep(0.1,0.9,length(st - vec2(0.5)))*scale/2.;
    st *= scale;
	st = abs(st - vec2(scale/2.,0.));

    const int octaves = 6;
    float lacunarity = 2.1;
    float gain = 0.4;
    //
    // Initial values
    float amplitude = 0.5;
    float frequency = 1.;
    //
	float y;
    // Loop of octaves
    for (int i = 0; i < octaves; i++) {
        y += amplitude * noise(frequency*st);
        frequency *= lacunarity;
        amplitude *= gain;
    }
    
    // Draw the min distance (distance field)
    // float factor = (m_dist+cdist-8.)/2.;
    color = smoothstep(0.72,0.82,vec3(y));
    // color = vec3(m_dist);

    // Draw cell center
    // color += 1.-step(.3, m_dist);

    // Draw grid
    // color.r += step(.98, f_st.x) + step(.98, f_st.y);

    // Show isolines
    // color -= step(.7,abs(sin(27.0*m_dist)))*.5;

    gl_FragColor = vec4(color,1.0);
}
