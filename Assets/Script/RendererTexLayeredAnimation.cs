using UnityEngine;


[ExecuteAlways]
[RequireComponent(typeof(MeshRenderer))]
public class RendererTexLayeredAnimation : MonoBehaviour
{
    public Sprite layer4;
    public Sprite layer3;
    public Sprite layer2;
    public Sprite layer1;

    private bool IsSpriteSet => layer1 is not null || layer2 is not null || layer3 is not null || layer4 is not null;

    private int _layer1ID = -1;
    private int Layer1ID => _layer1ID is -1 ? _layer1ID = Shader.PropertyToID("_Layer1") : _layer1ID;

    private int _layer2ID = -1;
    private int Layer2ID => _layer2ID is -1 ? _layer2ID = Shader.PropertyToID("_Layer2") : _layer2ID;

    private int _layer3ID = -1;
    private int Layer3ID => _layer3ID is -1 ? _layer3ID = Shader.PropertyToID("_Layer3") : _layer3ID;

    private int _layer4ID = -1;
    private int Layer4ID => _layer4ID is -1 ? _layer4ID = Shader.PropertyToID("_Layer4") : _layer4ID;

    private MeshRenderer meshRenderer;

    private MeshRenderer ThisMeshRenderer => meshRenderer? meshRenderer : meshRenderer = GetComponent<MeshRenderer>();

    private int defaultSortingOrder;

    private Texture defaultTexture;

    private Material material;

    protected Material ThisMaterial => material? material : material = ThisMeshRenderer.sharedMaterial;

    void OnDidApplyAnimationProperties()
    {
        if ( ThisMaterial is null) return;
        if ( IsSpriteSet is false ) return;
    
        if(layer1 is not null) ThisMaterial.SetTexture( Layer1ID , layer1.texture  );
        if(layer2 is not null) ThisMaterial.SetTexture( Layer2ID , layer2.texture  );
        if(layer3 is not null) ThisMaterial.SetTexture( Layer3ID , layer3.texture  );
        if(layer4 is not null) ThisMaterial.SetTexture( Layer4ID , layer4.texture  );

    }
    


}
