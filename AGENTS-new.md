# Multi-Agent Architecture

## Overview
這是一個多代理系統的架構說明，描述各個代理之間的互動與協作方式與相關的資料夾結構安排，與個別代理人相關的職責、工作流程、指令與技能，應根據個別資料夾定義進行詳細規劃。

## Folder Structure
| Folder Path    | Description                              |
| -------------- | ---------------------------------------- |
| .agents/skills | 存放專案所需要的技能模組，提供每個代理人使用 |
| .agents/agents | 存放各個代理人的職責與工作流程說明，並透過`AGENTS.md` 進行統一管理 |
| .agents/instructions | 存放專門針對不同開發情境所需要的指令與規範，例如:Python Code Standard、後端MVC架構等 |
| .agents/instructions/common-instructions.md | 存放此專案中，所有代理人皆需要遵守的共用指令與規範 |
| .github        | 主要存放Github相關代理人所需的基本配置，但是會使它導讀至共用配置檔案，減少重複撰寫代理人的職責與流程說明 |
| Features/Document     | 存放提供代理人閱讀`PM`所提出需求說明的相關資料，例如:需求說明文件、情境說明與系統流程圖等 |
| Features/Issue | 存放由代理人提供關於系統設計與實作的問題，會由相關代理人進行撰寫 |
| Features/Plan | 存放代理人根據`PM`所提出的需求進行系統開發計畫的相關說明 |
| Features/Review | 存放代理人對系統實作進行的審查與回饋 |

```text
project-root/
├─ .agents/
│  ├─ skills/
│  ├─ agents/
│  └─ instructions/
│     └─ common-instructions.md
├─ .github/
├─ Features/
│  ├─ Document/
│  ├─ Issue/
│  ├─ Plan/
│  └─ Review/
```

## Agents

此章節主要說明各個代理人的職責、工作流程以及代理人之間的互動方式。
- [System Design Agent](.agents/agents/system-design-agent.md)
- [Code Review Agent](.agents/agents/code-review-agent.md)
- [Programmer Agent](.agents/agents/programmer-agent.md)


### System Design Agent
主要負責閱讀`PM`所提出的需求，並根據專案需求進行系統設計與規範，並將相關計畫內容整理與紀錄至指定資料夾中，主要工作為：
- Requirement Analysis
- Requirement Change Analysis
- Bug / Behavior Analysis
- Existing System Analysis
- System Design
- Impact Analysis
- Implementation Plan
- Plan Update

### Code Review Agent
主要負責對程式碼進行審查，確保程式碼符合專案規範與設計要求，並將審查結果與回饋紀錄至指定資料夾中。
主要工作為：
- Implementation Review
- Code Quality Review
- Plan Compliance Review
- Test Review
- Regression Risk Review
- Review Fix Validation

### Programmer Agent
主要負責根據`System Design Agent`所提供的系統設計與規範進行程式開發，並將開發過程中的問題與進度紀錄至指定資料夾中。同時根據`Features/Review`中的回饋進行程式碼修改與優化，確保最終程式碼符合專案需求與規範。
主要工作為：
- Application Implementation
- Unit Test Implementation
- Regression Fix
- Plan Update Implementation
- Code Review Fix

### Agents Working Method

代理人工作模式：**Manual**

請根據*代理人工作方法*進行對應的操作與配置
- **Manual**：切換代理人之間的作業由使用者自行操作與控制，包含想要使用的代理人與模型的選擇與切換，相關[工作流程](./agents-mmd/Manual-Workflow.mmd)
- **Automatic**：代理人之間的作業由系統自動進行，根據預先設定的規則與流程，自動選擇適當的代理人與模型完成任務，相關[工作流程](./agents-mmd/Automatic-Workflow.mmd)


## Skills


## Instructions


## Features Folder

