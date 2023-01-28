using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

[RequireComponent(typeof(MeshRenderer))]
public class water_manager : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private ParticleSystem SplashParticles;
    [SerializeField] private BoxCollider _collider;

    [SerializeField] private Vector4 WaveA;
    [SerializeField] private Vector4 WaveB;
    [SerializeField] private Vector4 WaveC;
    private MeshRenderer _meshRenderer;

    [SerializeField] private float _Tiling = 1;
    //[SerializeField] private float Speed = 1;
    void Start()
    {
        _meshRenderer = GetComponent<MeshRenderer>();
        
        
    }

    private void OnTriggerEnter(Collider other)
    {
        
        if (other.CompareTag("Player"))
        {
            var emitparams = new ParticleSystem.EmitParams();
            emitparams.applyShapeToPosition = true;
            emitparams.position = _collider.ClosestPointOnBounds(other.attachedRigidbody.position) + (Vector3.down*6);
            emitparams.velocity =  Vector3.up *other.GetComponent<Rigidbody>().velocity.magnitude;
            SplashParticles.Emit(emitparams, 100);
            
            //SplashParticles.Play();
            //SplashParticles.Pause();
        }
    }

    // Update is called once per frame
    void Update()
    {
        _meshRenderer.material.SetFloat("_Tiling", _Tiling);
        _meshRenderer.material.SetVector("_WaveA", WaveA);
        _meshRenderer.material.SetVector("_WaveB", WaveB);
        _meshRenderer.material.SetVector("_WaveC", WaveC);
    }
}
