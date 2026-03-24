# BXB Stage Effects - Documentação Completa

Sistema de controle de efeitos especiais (partículas, fogos, fumaça, fogos de artifício) para FiveM.

## ⚠️ IMPORTANTE - Arquivos Ofuscados

**ATENÇÃO:** Os arquivos `client.lua` e `server.lua` estão **OFUSCADOS** e **NÃO DEVEM SER MODIFICADOS**.

- ✅ **Modifique APENAS:** `config.lua` e `permissions.lua`
- ❌ **NÃO modifique:** `client.lua`, `server.lua`, `html/script.js`, `html/style.css`, `html/index.html`

Toda a configuração é feita através do arquivo `config.lua`. Não é necessário e não é permitido modificar os arquivos ofuscados.

## Comandos

*   `/efeitos` - Abre o painel de controle de efeitos especiais. (Requer permissão de admin)

---

## Configuração Simplificada (config.lua)

A configuração foi simplificada para facilitar o uso. Você só precisa configurar:

1. **Área do Stage** (zona permitida)
2. **Nome do botão** (Label)
3. **Efeito** (nome do efeito pré-configurado)
4. **Coordenada** (onde o efeito aparecerá)
5. **Rotação** (opcional, padrão 0.0)

### 1. Zonas Permitidas (Allowed Zones)

Configure onde os comandos podem ser usados:

```lua
Config.AllowedZones = {
    {
        Coords = vector3(1109.93, -694.79, 57.42), -- Coordenada central do palco
        Radius = 50.0 -- Raio em metros
    }
}
```

---

### 2. Efeitos Disponíveis

#### PARTICULAS (Interaction: "hold" - Segurar para ativar)

| Nome do Efeito | Descrição |
|----------------|-----------|
| **Fire** | Chamas de fogo (burst rápido) |
| **Smoke** | Fumaça/vapor contínuo |
| **Spark** | Faíscas (burst) |
| **Confetti** | Confetes coloridos (burst) |

#### FIREWORKS (Interaction: "toggle" - Clique para ligar)

| Nome do Efeito | Descrição |
|----------------|-----------|
| **Color 1** | Fogos de artifício coloridos (vermelho/branco/azul) |
| **Color 2** | Fogos de artifício coloridos (verde/vermelho/branco) |
| **White** | Fogos de artifício brancos |
| **Stars** | Fogos de artifício em formato de estrelas (com prop) |

---

### 3. Estrutura da Configuração

#### Categoria PARTICULAS

```lua
{
    Label = "PARTICULAS",        -- OBRIGATÓRIO: Deve ser exatamente "PARTICULAS"
    Items = {
        {
            Label = "Fire",              -- Nome do botão
            Effect = "Fire",             -- Nome do efeito (veja tabela acima)
            Coords = vector3(x, y, z),   -- Coordenada onde aparecerá
            Rotation = 0.0                -- Rotação (opcional, padrão 0.0)
        }
    }
}
```

**Nota:** `Interaction` e `ShowStop` são definidos automaticamente:
- `Interaction = "hold"` (segurar para ativar)
- `ShowStop = false` (não mostra STOP ALL)

#### Categoria FIREWORKS

```lua
{
    Label = "FIREWORKS",         -- OBRIGATÓRIO: Deve ser exatamente "FIREWORKS"
    Items = {
        {
            Label = "Color 1",
            Effect = "Color 1",
            Coords = vector3(x, y, z),   -- Coordenada única
            Rotation = 0.0
        },
        -- OU múltiplas coordenadas:
        {
            Label = "White",
            Effect = "White",
            Coords = {
                vector3(x1, y1, z1),
                vector3(x2, y2, z2),
                vector3(x3, y3, z3)
            },
            Rotation = 0.0
        }
    }
}
```

---

### 4. Exemplo Completo de Configuração

```lua
Config = {}

-- 1. Zona Permitida
Config.AllowedZones = {
    {
        Coords = vector3(1109.93, -694.79, 57.42),
        Radius = 50.0
    }
}

-- 2. Categorias e Efeitos
Config.Categories = {
    {
        Label = "PARTICULAS",
        Items = {
            {
                Label = "Fire",
                Effect = "Fire",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Smoke",
                Effect = "Smoke",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Spark",
                Effect = "Spark",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            },
            {
                Label = "Confetti",
                Effect = "Confetti",
                Coords = vector3(1109.93, -694.79, 57.42),
                Rotation = 0.0
            }
        }
    },
    {
        Label = "FIREWORKS",
        Items = {
            {
                Label = "Color 1",
                Effect = "Color 1",
                Coords = {
                    vector3(1098.82, -700.15, 73.12),
                    vector3(1097.75, -689.26, 73.12)
                },
                Rotation = 0.0
            },
            {
                Label = "Color 2",
                Effect = "Color 2",
                Coords = {
                    vector3(1114.15, -671.89, 81.27),
                    vector3(1120.28, -713.18, 76.73)
                },
                Rotation = 0.0
            },
            {
                Label = "White",
                Effect = "White",
                Coords = {
                    vector3(1120.0, -692.0, 60.0),
                    vector3(1128.0, -692.0, 60.0),
                    vector3(1124.0, -688.0, 60.0),
                    vector3(1124.0, -696.0, 60.0)
                },
                Rotation = 0.0
            },
            {
                Label = "Stars",
                Effect = "Stars",
                Coords = {
                    vector3(1126.71, -696.02, 57.42),
                    vector3(1125.87, -688.28, 57.42)
                },
                Rotation = 0.0
            }
        }
    }
}
```

---

### 5. Parâmetros da Configuração

#### Categoria

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|------------|-----------|
| `Label` | string | ✅ Sim | Nome da categoria no menu. Deve ser exatamente **"PARTICULAS"** ou **"FIREWORKS"** |
| `Items` | table | ✅ Sim | Lista de efeitos (array de itens) |

**Valores Automáticos (não configuráveis):**
- **PARTICULAS**: `Interaction = "hold"`, `ShowStop = false`
- **FIREWORKS**: `Interaction = "toggle"`, `ShowStop = true`

#### Item (Efeito)

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|------------|-----------|
| `Label` | string | ✅ Sim | Nome do botão no menu |
| `Effect` | string | ✅ Sim | Nome do efeito pré-configurado (veja tabela de efeitos) |
| `Coords` | vector3/table | ✅ Sim | Coordenada única ou array de coordenadas |
| `Rotation` | number | ❌ Não | Rotação do efeito (padrão: 0.0) |

---

### 6. Coordenadas

Você pode usar uma única coordenada ou múltiplas coordenadas:

**Coordenada única:**
```lua
Coords = vector3(1109.93, -694.79, 57.42)
```

**Múltiplas coordenadas (array):**
```lua
Coords = {
    vector3(1109.93, -694.79, 57.42),
    vector3(1110.22, -687.66, 57.24),
    vector3(1111.68, -700.24, 57.24)
}
```

**Nota sobre Props:** 
- Para **PARTICULAS** (hold): O sistema automaticamente cria um prop `prop_cs_pour_tube` em cada coordenada
- Para **FIREWORKS** (toggle): Os props NÃO são criados, EXCETO para o efeito "Stars" que sempre terá props
- As partículas aparecem 0.15 unidades acima do prop (ou da coordenada se não houver prop)

---

### 7. Como Funciona

#### Categoria PARTICULAS (Interaction: "hold")
- **Segurar o botão:** Efeito ativa e continua enquanto o botão está pressionado
- **Soltar o botão:** Efeito para imediatamente
- **Props:** Automaticamente criados em todas as coordenadas

#### Categoria FIREWORKS (Interaction: "toggle")
- **Clicar no botão:** Efeito inicia e continua até ser parado
- **Clicar em "STOP ALL":** Para todos os efeitos ativos da categoria
- **Props:** NÃO são criados automaticamente (exceto para "Stars")

---

### 8. Dicas

1. **Coordenadas:** Use um editor de coordenadas (como o MLO Editor) para obter coordenadas precisas
2. **Testar:** Sempre teste os efeitos no jogo para verificar se as coordenadas estão corretas
3. **Múltiplas Coordenadas:** Use múltiplas coordenadas para criar efeitos em vários pontos simultaneamente
4. **Rotação:** A rotação é opcional, use apenas se necessário ajustar a direção do efeito

---

## Permissões (permissions.lua)

O arquivo `permissions.lua` controla o acesso ao painel de efeitos.

### Adicionar Admins

Edite `Config.Admins` para adicionar IDs:

```lua
Config.Admins = {
    "discord:1234567890123456",
    "discord:9876543210987654"
}
```

---

## Suporte

Para problemas ou dúvidas, verifique:
1. Se as coordenadas estão corretas
2. Se o nome do efeito está correto (veja tabela de efeitos disponíveis)
3. Se as zonas permitidas estão configuradas
4. Se a estrutura do config está correta
