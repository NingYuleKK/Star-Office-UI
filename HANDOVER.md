# HANDOVER.md - Star Office UI 项目交接文档

> 奉孝 session 重启时直接读这个文件恢复上下文，5分钟内接上昨天的进度。

---

## 📍 一句话总结

**Star Office UI** — 像素风多 Agent 可视化办公室看板。AI 助手根据状态走到不同区域，展示昨日小记，支持多 Agent 协作。

---

## 🌐 访问地址

| 环境 | 地址 |
|------|------|
| 公网（固定） | **https://fengxiao.cc** |
| 本地 | http://127.0.0.1:17291 |

---

## 🖥️ 技术架构

| 组件 | 详情 |
|------|------|
| 前端 | `frontend/` 像素风静态页面 |
| 后端 | Python Flask，端口 17291 |
| Tunnel | Cloudflare Named Tunnel `star-office` |
| Tunnel ID | `0b653e63-c72a-4de3-bb52-dba97c53cf60` |
| Tunnel 配置 | `~/.cloudflared/config.yml` |
| 状态文件 | `state.json`（主状态） |
| Agent 状态 | `agents-state.json` |

---

## 🚀 启动方式

```bash
cd /Users/litch/Star-Office-UI

# 启动后端
cd backend && python3 app.py &

# 启动 Named Tunnel（固定域名，不会变）
cd .. && ./start-tunnel.sh &
```

**检查是否在跑：**
```bash
ps aux | grep -E "app.py|cloudflared" | grep -v grep
```

---

## 📋 当前进展

- [x] 项目部署完成（2026-03-01）
- [x] Cloudflare Named Tunnel 配置（fengxiao.cc）（2026-03-02）
- [ ] 修改 Agent 名字（当前显示「海辛小龙虾」，应改为「奉孝」）
- [ ] 修复昨日小记（读取 `~/.openclaw/workspace/memory/YYYY-MM-DD.md`，当前无日志显示）
- [ ] 多 Agent 接入（Manus、元直）

---

## 👥 Agent 配置

| Agent | 名字 | 状态 | 推送方式 |
|-------|------|------|--------|
| 奉孝（OpenClaw） | 待修改 | 接入中 | `office-agent-push.py` |
| Manus | - | 待接入 | - |
| 元直 | - | 待接入 | - |

---

## ⚠️ 已知问题

1. **名字显示错误**：Agent 名字还显示「海辛小龙虾」，需要修改配置
2. **昨日小记不显示**：backend 读取 `~/.openclaw/workspace/memory/` 目录，需排查路径和文件格式

---

## 📝 更新记录

- **2026-03-02 16:30** — Named Tunnel 配置完成，fengxiao.cc 上线 ✅
- **2026-03-01** — 项目创建，基础功能完成，临时 Tunnel 可用

---

*最后更新：2026-03-02 by 奉孝*
