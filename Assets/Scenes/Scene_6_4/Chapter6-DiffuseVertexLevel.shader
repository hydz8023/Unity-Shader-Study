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
                //模型空间的顶点坐标
                float4 vertex : POSITION;
                //模型空间的法线方向
                float3 normal : NORMAL;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v v){
                v2f o;
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