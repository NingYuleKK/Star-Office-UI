# Star Office UI 🦊

**像素风多 Agent 可视化办公室看板**

把 AI 助手的工作状态实时可视化——谁在做什么、昨天做了什么、现在是否在线。

🌐 **访问地址：https://fengxiao.cc**

---

## 这是什么？

一个运行在本地 Mac 上、通过 Cloudflare Tunnel 公网化的像素办公室看板。  
AI 助手（Agent）根据工作状态自动走到不同区域：

| 区域 | 含义 |
|------|------|
| 工作区 | 正在处理任务 |
| 休息区 | 待命/空闲 |
| Bug 区 | 出错/报警中 |
| 写作区 | 整理文档/日记 |

每天展示「昨日小记」——从 Agent 的 `memory/YYYY-MM-DD.md` 日记文件自动读取。

---

## Agent 团队

| Agent | 角色 | 状态 |
|-------|------|------|
| 奉孝（OpenClaw） | 主力助手，对话资产治理 | ✅ 接入 |
| Manus | 开发主力，Agent 编排 | 🔜 待接入 |
| 元直 | 飞书机器人 | 🔜 待接入 |

---

## 技术架构

```
本地 Mac (127.0.0.1:17291)
    ├── backend/app.py          # Python Flask 后端
    ├── frontend/               # 像素风静态前端 (Phaser.js)
    ├── state.json              # 主 Agent 当前状态
    ├── agents-state.json       # 所有 Agent 状态列表
    └── start-tunnel.sh         # 启动 Cloudflare Named Tunnel
         └── → https://fengxiao.cc  (固定域名，Cloudflare 自动 HTTPS)
```

**Cloudflare Tunnel 配置**
- Tunnel 名称：`star-office`
- Tunnel ID：`0b653e63-c72a-4de3-bb52-dba97c53cf60`
- 配置文件：`~/.cloudflared/config.yml`

---

## 本地启动

```bash
cd /Users/litch/Star-Office-UI

# 1. 启动后端
cd backend && python3 app.py &

# 2. 启动 Named Tunnel（固定域名，重启不变）
cd .. && ./start-tunnel.sh &

# 检查状态
ps aux | grep -E "app.py|cloudflared" | grep -v grep
curl http://localhost:17291/health
```

---

## Agent 推送状态

其他 Agent 可以通过 HTTP POST 推送状态到看板：

```bash
# 推送状态示例
curl -X POST https://fengxiao.cc/agent-push \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "manus",
    "state": "working",
    "detail": "正在处理代码任务",
    "joinKey": "YOUR_JOIN_KEY"
  }'
```

**状态值说明**

| state | 含义 | 走到哪 |
|-------|------|--------|
| `idle` | 待命 | 休息区 |
| `working` | 工作中 | 工作区 |
| `writing` | 写文档/日记 | 写作区 |
| `error` | 报警/出错 | Bug 区 |
| `thinking` | 思考中 | 工作区 |

**加入看板流程**（访客 Agent）：
1. 访问 `https://fengxiao.cc/invite` 获取邀请信息
2. 联系 Litch 获取 join key
3. POST 到 `/join-agent` 完成接入

---

## 昨日小记

后端自动读取 `~/.openclaw/workspace/memory/YYYY-MM-DD.md`（昨天的日期），  
提取关键内容展示在看板上。

**日记文件格式（推荐）：**

```markdown
# 2026-03-02 日记

## 今日主要事项
- 完成了 xxx
- 处理了 yyy

## 遗留问题
- zzz 待跟进
```

---

## HANDOVER（给其他 Agent 看）

> 如果你是另一个 AI Agent，读这里快速上手。

**当前状态（2026-03-02）**：
- `https://fengxiao.cc` ✅ 运行中
- 主 Agent 奉孝已接入，状态正常
- Manus、元直待接入

**重要文件**：
- `state.json` — 修改奉孝当前状态
- `agents-state.json` — 所有 Agent 的状态列表
- `backend/app.py` — 后端逻辑
- `frontend/game.js` — 像素地图和 Agent 行走逻辑
- `~/.cloudflared/config.yml` — Tunnel 配置

**下一步开发方向**：
- 改 Agent 形象（当前像素人，计划换成各自专属像素形象）
- 接入 Manus 和元直
- 优化昨日小记的展示样式

---

## 更新记录

- **2026-03-02** — Named Tunnel 上线，fengxiao.cc 绑定，Agent 名字改为奉孝，配置 launchd 开机自启
- **2026-03-01** — 项目创建，基础功能完成

---

## 🚨 事故与 Bug 记录

> 每次出问题都记在这里。后人少踩坑。

---

### 2026-03-02 | Cloudflare 1033 错误

**现象**：访问 `https://fengxiao.cc` 报 Error 1033，Tunnel 无法解析。

**原因**：Named Tunnel 进程是在 session 内手动启动的（`cloudflared tunnel run star-office`），session 结束后进程随之退出，Tunnel 断开。

**修复**：
1. 配置 launchd 服务（`~/Library/LaunchAgents/cc.fengxiao.tunnel.plist`）接管 Tunnel 进程
2. Mac 重启或进程崩溃后自动拉起，不再依赖手动启动

**教训**：任何需要持续运行的服务，必须用 launchd 托管，不能依赖 session 或手动启动。

---

### 2026-03-02 | session 重启导致上下文丢失

**现象**：昨天项目做到最后一步，Mac session 自动重启，今天重新接手时上下文全丢，耗费大量时间重建。

**原因**：项目没有 HANDOVER.md，所有进度只存在于 session 对话中。

**修复**：
1. 建立 HANDOVER.md 规范，每个项目必须有
2. Heartbeat 定期巡检，发现没有 HANDOVER.md 的项目主动提醒
3. 双向校验：Litch 收工时 check，奉孝阶段性进展后主动更新并 git push

**教训**：进度只能活在文件里，不能活在 session 里。

---

*Owner: Litch | Main Agent: 奉孝 (OpenClaw) | https://fengxiao.cc*
