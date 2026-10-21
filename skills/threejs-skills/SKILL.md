---
name: threejs-skills
description: "Comprehensive Three.js, WebGL, 3D graphics, and shader intelligence suite."
---

# Three.js 3D & WebGL Engineering Suite

Expert guidance for creating high-performance, interactive, and beautifully animated 3D web experiences using Three.js and WebGL.

## Modular Skill Capabilities

| Skill | Focus Area | What it Covers |
| :--- | :--- | :--- |
| **[`threejs-core`](../threejs-core/SKILL.md)** | Scene & WebGL | Renderer initialization, scene setup, aspect-ratio handling, and `requestAnimationFrame` render loops. |
| **[`threejs-animation`](../threejs-animation/SKILL.md)** | Motion & Animation | `AnimationMixer`, `AnimationClip`, keyframe tracks, skeletal animation, morph targets, and GSAP tween integration. |
| **[`threejs-shaders`](../threejs-shaders/SKILL.md)** | Custom GLSL | `ShaderMaterial`, `RawShaderMaterial`, vertex/fragment shaders, uniforms, noise functions, and GPU effects. |
| **[`threejs-materials`](../threejs-materials/SKILL.md)** | PBR & Textures | `MeshStandardMaterial`, `MeshPhysicalMaterial`, environment maps (HDR/EXR), roughness/metalness maps, and matcaps. |
| **[`threejs-lighting`](../threejs-lighting/SKILL.md)** | Illumination & Shadows | Directional, point, spot, ambient lights, shadow maps (`PCFSoftShadowMap`), and studio lighting rigs. |
| **[`threejs-loaders`](../threejs-loaders/SKILL.md)** | 3D Asset Loading | `GLTFLoader`, `DRACOLoader` compression, `TextureLoader`, `RGBELoader`, and `LoadingManager` progress bars. |
| **[`threejs-geometry`](../threejs-geometry/SKILL.md)** | Mesh & Geometry | `BufferGeometry`, custom vertex attributes, procedural meshes, and `InstancedMesh`. |
| **[`threejs-camera`](../threejs-camera/SKILL.md)** | View & Navigation | `PerspectiveCamera`, `OrthographicCamera`, `OrbitControls`, pointer lock, and camera transitions. |
| **[`threejs-postprocessing`](../threejs-postprocessing/SKILL.md)** | Screen FX | `EffectComposer`, Unreal Bloom, depth of field, vignette, film grain, and chromatic aberration. |
| **[`threejs-physics`](../threejs-physics/SKILL.md)** | Simulations | Rigid body dynamics, gravity, collisions, and Raycasting using Cannon-es or Rapier. |
| **[`threejs-performance`](../threejs-performance/SKILL.md)** | Optimization | Draw call batching, memory disposal, frustum culling, LOD, and 60fps mobile profiling. |
| **[`threejs-react`](../threejs-react/SKILL.md)** | R3F & Drei | React Three Fiber ecosystem, canvas hooks (`useFrame`, `useThree`), and Drei components. |
| **[`threejs-audio`](../threejs-audio/SKILL.md)** | Positional Audio | 3D audio listeners, sound emitters, and spatial soundscapes. |
| **[`threejs-xr`](../threejs-xr/SKILL.md)** | VR & AR | WebXR manager, VR controllers, and immersive spatial experiences. |

## Quick Start: Standard Three.js + Vite Template

```javascript
import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';

// 1. Scene, Camera, Renderer
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.set(0, 2, 5);

const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;
document.body.appendChild(renderer.domElement);

// 2. Controls & Lights
const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;

const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
scene.add(ambientLight);

const dirLight = new THREE.DirectionalLight(0xffffff, 1.5);
dirLight.position.set(5, 10, 7);
dirLight.castShadow = true;
scene.add(dirLight);

// 3. Animation Loop
const clock = new THREE.Clock();
function animate() {
  requestAnimationFrame(animate);
  const elapsedTime = clock.getElapsedTime();
  controls.update();
  renderer.render(scene, camera);
}
animate();

// 4. Resize Handling
window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});
```
