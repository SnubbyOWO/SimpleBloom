using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class BloomEffect : MonoBehaviour
{
    [SerializeField] private Shader _bloomShader;
    [SerializeField, Range(0f, 1f)] private float _threshold = 0.9f;
    [SerializeField, Range(0f, 10f)] private float _intensity = 2f;
    [SerializeField, Range(0f, 5f)] private float _radius = 2f;

    private Material _bloomMaterial;
    private Camera _camera;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_bloomMaterial == null)
        {
            _bloomMaterial = new Material(_bloomShader);
            _bloomMaterial.hideFlags = HideFlags.HideAndDontSave;
        }

        _bloomMaterial.SetFloat("_Threshold", _threshold);
        _bloomMaterial.SetFloat("_BloomIntensity", _intensity);
        _bloomMaterial.SetFloat("_BloomRadius", _radius);

        Graphics.Blit(source, destination, _bloomMaterial, 0);
    }

    private void OnDisable()
    {
        if (_bloomMaterial != null)
        {
            DestroyImmediate(_bloomMaterial);
        }
    }

    private void OnEnable()
    {
        _camera = GetComponent<Camera>();
        _camera.depthTextureMode |= DepthTextureMode.Depth;
    }
}