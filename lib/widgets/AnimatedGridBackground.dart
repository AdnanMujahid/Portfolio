import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Drop-in replacement for the old AnimatedGridBackground.
///
/// Renders the Brutalist WebGL shader (animated grid + mouse-reactive bloom)
/// inside a transparent [InAppWebView], filling whatever space it is given.
/// Everything else in the app is unchanged.
class AnimatedGridBackground extends StatelessWidget {
  const AnimatedGridBackground({super.key});

  // The full shader HTML, inlined so no asset file is needed.
  static const String _html = r'''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width,initial-scale=1.0" name="viewport"/>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    width: 100%;
    height: 100%;
    overflow: hidden;
    background: #000;
  }
</style>
</head>
<body>
<div style="position:fixed;inset:0;width:100%;height:100%;display:block;">
<canvas id="shader-canvas" style="display:block;width:100%;height:100%"></canvas>
<script>
(function() {
  const canvas = document.getElementById('shader-canvas');

  function syncSize() {
    const w = canvas.clientWidth  || 1280;
    const h = canvas.clientHeight || 720;
    if (canvas.width !== w || canvas.height !== h) {
      canvas.width  = w;
      canvas.height = h;
    }
  }
  if (typeof ResizeObserver !== 'undefined') {
    new ResizeObserver(syncSize).observe(canvas);
  }
  syncSize();

  const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
  if (!gl) return;

  const vs = `attribute vec2 a_position;
varying vec2 v_texCoord;
void main() {
  v_texCoord = a_position * 0.5 + 0.5;
  gl_Position = vec4(a_position, 0.0, 1.0);
}`;

  const fs = `precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
varying vec2 v_texCoord;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    vec2 uv = v_texCoord;
    vec2 mouse = u_mouse / u_resolution;

    // Grid pattern
    float gridSize = 20.0;
    vec2 gridUv = fract(uv * gridSize);
    float grid = step(0.98, gridUv.x) + step(0.98, gridUv.y);

    // Moving blobs
    float dist = distance(uv, mouse);
    float bloom = 0.05 / (dist + 0.1);

    // Brutalist Accent Colors
    vec3 blue  = vec3(0.23, 0.51, 0.96); // #3B82F6
    vec3 pink  = vec3(0.96, 0.25, 0.37); // #F43F5E
    vec3 green = vec3(0.06, 0.73, 0.51); // #10B981

    // Wave motion
    float wave  = sin(uv.x * 5.0 + u_time) * 0.5 + 0.5;
    float wave2 = cos(uv.y * 3.0 - u_time * 0.8) * 0.5 + 0.5;

    vec3 color = vec3(0.97, 0.98, 0.98); // Light surface
    color = mix(color, blue, bloom * wave);
    color = mix(color, pink, bloom * wave2 * 0.5);

    // Subtle noise for texture
    color += (random(uv + u_time * 0.01) - 0.5) * 0.02;

    // Faint grid overlay
    color = mix(color, vec3(0.0, 0.0, 0.0), grid * 0.05);

    gl_FragColor = vec4(color, 1.0);
}`;

  function cs(type, src) {
    const s = gl.createShader(type);
    gl.shaderSource(s, src);
    gl.compileShader(s);
    return s;
  }

  const prog = gl.createProgram();
  gl.attachShader(prog, cs(gl.VERTEX_SHADER, vs));
  gl.attachShader(prog, cs(gl.FRAGMENT_SHADER, fs));
  gl.linkProgram(prog);
  gl.useProgram(prog);

  const buf = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buf);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1,-1, 1,-1, -1,1, 1,1]), gl.STATIC_DRAW);

  const pos = gl.getAttribLocation(prog, 'a_position');
  gl.enableVertexAttribArray(pos);
  gl.vertexAttribPointer(pos, 2, gl.FLOAT, false, 0, 0);

  const uTime  = gl.getUniformLocation(prog, 'u_time');
  const uRes   = gl.getUniformLocation(prog, 'u_resolution');
  const uMouse = gl.getUniformLocation(prog, 'u_mouse');

  let mouse = { x: canvas.width / 2, y: canvas.height / 2 };
  window.addEventListener('mousemove', (event) => {
    const rect = canvas.getBoundingClientRect();
    if (rect.width && rect.height) {
      const nx = (event.clientX - rect.left) / rect.width;
      const ny = 1.0 - (event.clientY - rect.top) / rect.height;
      mouse.x = nx * canvas.width;
      mouse.y = ny * canvas.height;
    }
  });

  function render(t) {
    if (typeof ResizeObserver === 'undefined') syncSize();
    gl.viewport(0, 0, canvas.width, canvas.height);
    if (uTime)  gl.uniform1f(uTime, t * 0.001);
    if (uRes)   gl.uniform2f(uRes, canvas.width, canvas.height);
    if (uMouse) gl.uniform2f(uMouse, mouse.x, mouse.y);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
    requestAnimationFrame(render);
  }
  render(0);
})();
</script>
</div>
</body>
</html>''';

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: _html,
        mimeType: 'text/html',
        encoding: 'utf-8',
      ),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        disableVerticalScroll: true,
        disableHorizontalScroll: true,
        // Enable WebGL / hardware acceleration
        hardwareAcceleration: true,
        // Suppress the address bar / scroll indicators
        scrollBarStyle: ScrollBarStyle.SCROLLBARS_OUTSIDE_INSET,
      ),
    );
  }
}