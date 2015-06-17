**Gakuen Hetalia** es un juego para la *Nintendo DS* desarrollado por *Otomate Idea* en 2012. Se trata de un juego que no salió de Japón y que sigue la saga de *Hetalia*. Está dentro del género de aventura y comedia.


## Imágenes
Tienen una compresión propietaria. Se adjunta programa para descomprimir en C#.
```csharp
// Initialize values
byte[] list = new byte[0x10];
Array.Copy(BitConverter.GetBytes(0xFFFFFFFE), 0, list, 0, 4);
Array.Copy(BitConverter.GetBytes(0-width), 0, list, 4, 4);
Array.Copy(BitConverter.GetBytes(0-width-2), 0, list, 8, 4);
Array.Copy(BitConverter.GetBytes(0-width+2), 0, list, 12, 4);

// Start of decoding
while (pos_buf < dec_size)
{
    // Read encoding control code
    int control = data[pos_control++];

    // Check type of encoding
    if (control < 0x10)     // Copy X bytes
    {
        int loop = control + 1;
        for (; loop != 0; loop--, pos_enc += 2, pos_buf += 2)
        {
            short value = BitConverter.ToInt16(data, pos_enc);
            Array.Copy(BitConverter.GetBytes(value), 0, buffer, pos_buf, 2);
        }
    }
    else if (control < 0xC0)
    {
        int pos = -1 - control + 0x10;
        pos <<= 1;
        // Read past value
        short value = BitConverter.ToInt16(data, pos_enc + pos);
        Array.Copy(BitConverter.GetBytes(value), 0, buffer, pos_buf, 2);
        pos_buf += 2;
    }
    else
    {
        control -= 0xC0;

        int pos = control >> 4;
        pos <<= 2;
        pos = BitConverter.ToInt32(list, pos);
        pos += pos_buf;

        int loop = control & 0xF;
        loop++;

        for (; loop != 0; loop--, pos += 2, pos_buf += 2)
        {
            short value = BitConverter.ToInt16(buffer, pos);
            Array.Copy(BitConverter.GetBytes(value), 0, buffer, pos_buf, 2);
        }
    }
}
```

## Texto
Está cifrado con la clave `0xDA` mediante la operación XOR sobre cada byte.
