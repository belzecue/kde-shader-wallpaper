import QtQuick 2.12
import QtQuick.Controls 2.12
Item {
    property string pixelShader: "
    // From https://www.shadertoy.com/view/XdtfRB
    // Credits to sangwhan
    // Modified by @y4my4my4m
    //TODO: will make this customizable via GUI

    vec3 C = vec3(0.12, 0.11, 0.37);
    float GWM = 1.15;
    float TM = 0.25;

    float getAmp(float frequency) {
        return texture(iChannel0, vec2(frequency / 512.0, 0)).x;
    }

    float getWeight(float f) {
        return (getAmp(f - 2.0) + getAmp(f - 1.0) + \
                getAmp(f + 2.0) + getAmp(f + 13.0) + \
                getAmp(f)) / 5.0;
    }

    void mainImage( out vec4 fragColor, in vec2 fragCoord )
    {
          float iTimeMov = iTime / 6.0;  // speed hack for movement
          float iTimeCol = iTime * 1.0;  // speed hack for color
          //vec3 backdrop = mix(C, C, C);
          vec3 backdrop;
      	  vec2 uvTrue = fragCoord.xy / iResolution.xy;
          vec2 uv = 2.5 * uvTrue - 1.15;

      	  float li;
          float gw;
          float ts;
          float tsr;
          float tsg;
          float tsb;

          float cr;
          float cg;
          float cb;
          vec3 color = vec3(0.0);

    	for(float i = 0.0; i < 5.0; i++) {
    		  uv.y += (0.2 * sin(uv.x + i / 7.0 - iTimeMov * 0.4));
          float Y = uv.y + getWeight(pow(i, 2.0) * 20.0) * (texture(iChannel0, vec2(uvTrue.x, 1)).x - 0.5);
          li = 0.4 + pow(1.2 * abs(mod(uvTrue.x + i / 1.1 + iTimeMov, 2.0) - 1.0), 2.0);
  		    gw = abs(li / (150.0 * Y));

          ts  = gw * (GWM + sin(iTimeCol * TM));
          tsr = gw * (GWM + sin(iTimeCol * TM * 1.33));
          tsg = gw * (GWM + sin(iTimeCol * TM * 1.55));
          tsb = gw * (GWM + sin(iTimeCol * TM * 1.99));
  		    color += vec3(tsr, tsg, tsb);

          backdrop = mix(C * normalize(color), C * normalize(color), C * normalize(color));
    	}

    	fragColor = vec4(color + backdrop, 0.5);
    }"
}
