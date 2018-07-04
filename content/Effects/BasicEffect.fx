/************* Resources *************/

cbuffer CBufferPerObject
{
	float4x4 WorldViewProjection : WORLDVIEWPROJECTION;
}

/************* Data Structures *************/
struct temp
{};

struct VS_INPUT
{
	float4 ObjectPosition: POSITION;
	float4 Color : COLOR;
	float4 TexCoord: TEXCOORD;
};

struct VS_OUTPUT
{
	float4 Position: SV_Position;
	float4 Color : COLOR;
};

RasterizerState DisableCulling
{
	CullMode = NONE;
};

/************* Vertex Shader *************/

VS_OUTPUT vertex_shader(VS_INPUT IN)
{
	VS_OUTPUT OUT = (VS_OUTPUT)0;
	int ang = 45;
	matrix <float, 4, 4> rotate = { cos(ang), -sin(ang), 0, 0,
									sin(ang), cos(ang), 0, 0,
									0, 0, 1, 0,
									0, 0, 0, 1 };

	float4 pos = mul(IN.ObjectPosition, rotate);
	OUT.Position = mul(pos, WorldViewProjection);
	OUT.Color = IN.Color;
	//OUT.Color = (float4)(IN.Color.a - IN.Color.rgb, IN.Color.a);

	return OUT;
}

/************* Pixel Shader *************/

float4 pixel_shader(VS_OUTPUT IN) : SV_Target
{
	IN.Color.r = 1.0f;
	IN.Color.g = (cos(IN.Position));
	IN.Color.b = (sin(IN.Position));
	IN.Color.a = 1.0f;

	return IN.Color;
}

/********** Geometry Shader**************/
//[maxvertexcount(6)]
void geometry_shader()
{

}

/************* Techniques *************/

technique11 main11
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, vertex_shader()));
		SetGeometryShader(NULL);
		SetPixelShader(CompileShader(ps_5_0, pixel_shader()));

		SetRasterizerState(DisableCulling);
	}
}