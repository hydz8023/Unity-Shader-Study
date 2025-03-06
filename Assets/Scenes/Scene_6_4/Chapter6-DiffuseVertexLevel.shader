// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level"
{
    Properties{
        //声明一个Color类型的属性，并将初始值设为白色
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
    }
    SubShader{
        Pass{
            //指定该Pass的光照模式
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"//头文件

            fixed4 _Diffuse;

            struct a2v{
                //POSITION语义告诉Unity，用模型空间的顶点坐标填充vertex变量
                float4 vertex : POSITION;
                //NORMAL语义告诉Unity，用模型空间的法线方向填充normal变量
                float3 normal : NORMAL;
            };

            struct v2f{
                //SV_POSITION语义告诉Unity，pos里包含了顶点在裁剪空间中的位置信息
                float4 pos : SV_POSITION;
                //COLOR0语义可以用于存储颜色信息
                fixed3 color : COLOR;
            };

            v2f vert(a2v v){
                v2f o;
                //将顶点位置从模型空间转换到裁剪空间，这是顶点着色器最基本的任务
                o.pos = UnityObjectToClipPos(v.vertex);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));

                o.color = ambient + diffuse;


                return o;
            }
            
            fixed4 frag(v2f i):SV_Target{
                return fixed4(i.color, 1.0);
            }

            ENDCG
        }
    }

}