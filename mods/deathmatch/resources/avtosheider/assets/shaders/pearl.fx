//   инклюд помощника    //

#include "mta-helper.fx"

// переменные нужные нам //

texture sReflectionTexture;
texture sRandomTexture;
bool enableVinils = false;
texture gTexture;

float4 paintColor2 = float4(0.3, 0.3, 0.3, 0);
float microflakePerturbation = 0;
float brightnessFactor = 0.4;
float normalPerturbation = 0.05;
float microflakePerturbationA = 0;

//      sampler'ы       //

sampler Sampler0 = sampler_state
{
	Texture 		= (gTexture);
	MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler3D RandomSampler = sampler_state
{
	Texture 		= (sRandomTexture);
	MAGFILTER 		= LINEAR;
	MINFILTER 		= LINEAR;
	MIPFILTER 		= POINT;
};

samplerCUBE ReflectionSampler = sampler_state
{
	Texture 		= (sReflectionTexture);
	MAGFILTER 		= LINEAR;
	MINFILTER 		= LINEAR;
	MIPFILTER 		= LINEAR;
};

// структура для вертекса //

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal 	: NORMAL0;
    float4 Diffuse  : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

// вторая структура или пиксель хуй пойми //

struct PSInput
{
    float4 Position   : POSITION0;
    float4 Diffuse 	  : COLOR0;
    float2 TexCoord   : TEXCOORD0;
    float3 Tangent 	  : TEXCOORD1;
    float3 Binormal	  : TEXCOORD2;
    float3 Normal 	  : TEXCOORD3;
    float3 NormalSurf : TEXCOORD4;
    float3 View 	  : TEXCOORD5;
    float3 SparkleTex : TEXCOORD6;
};

// ето я спиздил потому что не понима. как оно работает //
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    float3 worldPosition = MTACalcWorldPosition( VS.Position );
    float3 viewDirection = normalize(gCameraPosition - worldPosition);

    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );
	
    // Transfer some stuff
    PS.TexCoord = VS.TexCoord;
	PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
    PS.NormalSurf = VS.Normal;
    PS.View = viewDirection;
    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0;

    // Calc lighting
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );

    return PS;
}
// наканеца пишу сам шейдар отрожений //
float4 PixelShaderFunction(PSInput PS) : COLOR0
{	
	
	float4 base = gMaterialAmbient;
    float4 paintColorMid;
    float4 paintColor0;
    float4 flakeLayerColor;
	paintColorMid = base;

    paintColor0.r = base.r / 2 + base.g / 2;
    paintColor0.g = (base.g / 2 + base.b / 2);
    paintColor0.b = base.b / 2 + base.r / 2;

    flakeLayerColor.r = base.r / 2 + base.b / 2;
    flakeLayerColor.g = (base.g / 2 + base.r / 2);
    flakeLayerColor.b = base.b / 2 + base.g / 2;
	//////////////////////////////////////////////////////////////////////////////////////
	float3 vNormal = PS.Normal;
	float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;
	
	//float3 vNp1 = microflakePerturbationA * vFlakesNormal + normalPerturbation * vNormal ;
	float3 vNp1 = vFlakesNormal + normalPerturbation ;
	float3 vNp2 = microflakePerturbation * ( vFlakesNormal + vNormal ) ;
	
	float3 vView = normalize( PS.View );
	float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));
	
	float fNdotV = saturate(dot( vNormalWorld, vView));
	
	float3 Nn = normalize(vNormal);
    float3 Vn = PS.View; 
	float3 vReflection = reflect(Vn,Nn);
	
	float4 envMap = texCUBE( ReflectionSampler, vReflection ); // текстура уже сама которая для отрожений
	envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;
	envMap.rgb *= brightnessFactor;
	
	float3 vNp1World = normalize( mul( mTangentToWorld, vNp1) );
    float fFresnel1 = saturate( dot( vNp1World, vView/2 ));
	
	float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, vView ));
	
	float4 paintColor = fFresnel1 * paintColor0 +
        fFresnel1 * paintColorMid +
        fFresnel1 * fFresnel1 * paintColor2 +
        pow( fFresnel2, 32 ) * flakeLayerColor;
	
	float fEnvContribution = 1.0 - 0.5 * fNdotV;
	
	float4 finalColor;
    finalColor = envMap * fEnvContribution + paintColor;
    finalColor.a = 1.0;
	
    float4 Color = 1;
	Color = finalColor / 1 + PS.Diffuse * 1;
    Color += finalColor * PS.Diffuse * 0.2;
	
	// а теперь винил сделаем но не так как надо а как даун
	float4 maptex = tex2D(Sampler0,PS.TexCoord.xy);
	if (enableVinils){
		Color *= maptex; 
	}
	
    return Color;
}

// Techniques
technique carpaint_fix_v2
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}