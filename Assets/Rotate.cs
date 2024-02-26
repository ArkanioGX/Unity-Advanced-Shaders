using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float speed = 0.5f; 
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //transform.rotation = Quaternion.Euler(Mathf.Cos(Time.time), Mathf.Sin(Time.time) + 180, Mathf.Tan(Time.time));
        transform.Rotate(Mathf.Cos(Time.time)*speed, Mathf.Sin(Time.time)*speed, Mathf.Tan(Time.time) * speed);
    }
}
