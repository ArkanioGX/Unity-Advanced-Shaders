using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float speed = 0.5f;
    public bool rotateX= true;
    public bool rotateY= true;
    public bool rotateZ= true;

    public bool pingPong = true;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 rot = Vector3.zero;
        if (pingPong)
        {
            rot = new Vector3(Mathf.Cos(Time.time) * speed * System.Convert.ToInt16(rotateX), Mathf.Sin(Time.time) * speed * System.Convert.ToInt16(rotateY), Mathf.Cos(Time.time) * speed * System.Convert.ToInt16(rotateZ));
        }
        else
        {
            rot = new Vector3(speed * System.Convert.ToInt16(rotateX), speed * System.Convert.ToInt16(rotateY), speed * System.Convert.ToInt16(rotateZ));
        }
        
        //transform.rotation = Quaternion.Euler(Mathf.Cos(Time.time), Mathf.Sin(Time.time) + 180, Mathf.Tan(Time.time));
        transform.Rotate(rot * Time.deltaTime);
    }
}
