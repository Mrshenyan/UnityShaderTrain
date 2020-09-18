using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderToy : MonoBehaviour {

    public Shader shaderToy;
    private Material shaderToyMaterial = null;
    public Material Material
    {
        get {
            shaderToyMaterial = GetMat(shaderToy, shaderToyMaterial);
            return shaderToyMaterial;
        }
    }

    private Material GetMat(Shader shader, Material material)
    {
        if (shader == null)
       {
           return null;
       }
       if (!shader.isSupported)
       {
            return null;
       }
       else
       {
           material = new Material(shader)
           {
               hideFlags = HideFlags.DontSave
           };
           return material;
       }
    }

    void OnRenderImage(RenderTexture source,RenderTexture destination)
    {
        Graphics.Blit(source, destination, Material);
    }

}
