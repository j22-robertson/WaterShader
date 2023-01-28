using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class watersplash : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private ParticleSystem SplashParticles;
    [SerializeField] private BoxCollider _collider;
    void Start()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        
        if (other.CompareTag("Player"))
        {
            var emitparams = new ParticleSystem.EmitParams();
            emitparams.applyShapeToPosition = true;
            emitparams.position = _collider.ClosestPointOnBounds(other.attachedRigidbody.position) + (Vector3.down*6);


            SplashParticles.Emit(emitparams, 100);
            //SplashParticles.Play();
            //SplashParticles.Pause();
        }
    }

    // Update is called once per frame
    void Update()
    {
       
    }
}
