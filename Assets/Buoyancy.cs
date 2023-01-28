using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Buoyancy : MonoBehaviour
{
    // Start is called before the first frame update
    private Rigidbody _rigidbody;
    private bool _underwater;
    private float _waterDrag = 3.0f;
    private float _waterAngularDrag = 1.0f;
    private float _airDrag = 0f;
    private float _airAngularDrag = 0.5f;

    [SerializeField] public float buoyancy_strength = 15.0f;
    [SerializeField] public float water_level =0.0f;
    
    void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();

    }

    // Update is called once per frame
    void FixedUpdate()
    {
        float height_difference = transform.position.y - water_level;

        if (height_difference < 0)
        {
            _rigidbody.AddForceAtPosition(Vector3.up * (buoyancy_strength * Mathf.Abs(height_difference)), transform.position, ForceMode.Force);
        }

        if (!_underwater)
        {
            _underwater = true;
            HandleStateChange(_underwater);
        }
        else if (_underwater)
        {
            _underwater = false;
            HandleStateChange(_underwater);
        }
    }

    void HandleStateChange(bool underwater)
    {
        if (underwater)
        {
            _rigidbody.drag = _waterDrag;
            _rigidbody.angularDrag = _waterAngularDrag;
        }
        else if (!underwater)
        {
            _rigidbody.drag = _airDrag;
            _rigidbody.angularDrag = _airAngularDrag;
        }
        
    }
}
