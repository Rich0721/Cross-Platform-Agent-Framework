# Cross-Platform Agent Framework

此專案是為了做出一個可以跨平台開發的代理人框架，方便開發者在不同專案底下都可以使用相同的工作方式進行開發的作業流程。

## 目錄架構
```text
.
├── .agents
│   ├── agents
│   └── skills
├── instructions
│   ├── code-standard-python.md
│   ├── code-standard-react.md
│   ├── code-standard-sql.md
│   └── code-standard-typescript.md
├── AGENTS.md
├── symbolic_link.sh
├── update_link.sh
└── README.md
```

| 目錄路徑 |  說明 |
| -------- | -------- |
| .agents/agents | 代理人定義檔案，目前總共有三個代理人：**System Design Agent**、**Programmer Agent**、**Code Review Agent** |
| .agents/skills | 代理人技能檔案 |
| instructions | 開發指引與規範文件 |
| AGENTS.md | 代理人總覽文件 |
| symbolic_link.sh | 建立符號連結的腳本 |
| update_link.sh | 更新符號連結的腳本 |
| README.md | 專案說明文件 |


## 代理人工作模式
`AGENTS.md`中定義不同代理人間要如何進行交付
- **Automatic**：代理人之間的作業由**系統自動進行**，根據預先設定的規則與流程，自動選擇適當的代理人與模型完成任務，相關工作流程請參考`AGENTS.md`中的說明
- **Manual**：切換代理人之間的作業由**使用者自行操作與控制**，包含想要使用的代理人與模型的選擇與切換，相關工作流程請參考`AGENTS.md`中的說明。
相關切換模型也請於`AGENTS.md`中進行設定與管理。

## 使用說明
使用`symbolic_link.sh`建立符號連結與`update_link.sh`更新符號連結，方便在不同專案中共用相同的代理人與技能。
注意：如果**AGENTS.md**中有新增的代理人或技能，請先更新符號連結，確保各專案使用的都是最新版本，且會同步更新相關的符號連結。

```bash
./symbolic_link.sh repo
```

若代理人或技能有更新，可以使用 `update_link.sh` 更新符號連結，確保各專案使用的都是最新版本。
```bash
./update_link.sh repo
```

### 注意事項
1. 如果有使用軟連結在不同的REPO，**代理人模式**會因為不同的符號連結修改而受到影響，如果需要在不同專案有不同的模式，請自行移除`AGENTS.md`的連結，並在各專案中建立各自的`AGENTS.md`。
2. 此專案的目標是為了提供一個統一的跨平台代理人開發框架，使開發者能夠在不同專案中使用相同的代理人與技能，提升開發效率與一致性，使用者可以自行管理各專案的代理人與技能設定，並透過符號連結保持與主專案的一致性。