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
| 后端 | Python Flask，**固定端口 17291**（勿改，18791 被 OpenClaw Gateway 占用） |
| Tunnel | Cloudflare Named Tunnel `star-office` |
| Tunnel ID | `0b653e63-c72a-4de3-bb52-dba97c53cf60` |
| Tunnel 配置 | `~/.cloudflared/config.yml` → 指向 127.0.0.1:17291 |
| 状态文件 | `state.json`（主状态） |
| Agent 状态 | `agents-state.json` |

---

## 🚀 启动方式

```bash
cd /Users/litch/Star-Office-UI

# 启动后端（必须指定端口，避开 OpenClaw Gateway 的 18791）
STAR_BACKEND_PORT=17291 nohup python3 backend/app.py >> flask.log 2>> flask.err &

# Tunnel 由 launchctl 管理，开机自启，一般不用手动启动
# 手动检查：launchctl list cc.fengxiao.tunnel
# 手动重启：launchctl stop cc.fengxiao.tunnel && launchctl start cc.fengxiao.tunnel
```

**检查是否在跑：**
```bash
ps aux | grep 'app.py' | grep -v grep          # Flask
launchctl list cc.fengxiao.tunnel               # Tunnel
curl -s http://localhost:17291/status           # 健康检查
```

**⚠️ 注意**：`ps aux | grep python` 可能漏掉 Flask 进程（进程名是 Python 全路径）。务必用 `grep app.py` 精确匹配。

---

## 📋 当前进展（2026-03-05 更新）

- [x] 项目部署完成（2026-03-01）
- [x] Cloudflare Named Tunnel 配置（fengxiao.cc）（2026-03-02）
- [x] 修改 Agent 名字为「奉孝」（2026-03-05）
- [x] **merge-upstream-v2 完成**（2026-03-05）— 全量美术重绘、资产侧边栏、生图 API、三语支持
- [x] 昨日小记路径修复（MEMORY_DIR → `~/.openclaw/workspace/memory`）
- [ ] 多 Agent 接入（Manus、元直）
- [ ] 狐狸精灵表制作（帧数要求高，暂缓）

---

## 🌿 分支状态

| 分支 | 状态 | 说明 |
|------|------|------|
| `master` | 旧版本 | 待合并 merge-upstream-v2 |
| `merge-upstream-v2` | **当前运行** ✅ | 2026-03-05 完成，已 push |

**下次待做**：把 `merge-upstream-v2` merge 进 `master`，验证无误后以 master 为主线。

---

## 👥 Agent 配置

| Agent | 名字 | 状态 | 推送方式 |
|-------|------|------|--------|
| 奉孝（OpenClaw） | 奉孝 ✅ | 运行中 | `office-agent-push.py` |
| Manus | - | 待接入 | - |
| 元直 | - | 待接入 | - |

---

## ⚠️ 端口约定（重要）

这台 Mac 上：
- **18791** → OpenClaw Gateway（Node.js Express，勿占）
- **17291** → Star Office Flask（固定）
- **18789** → OpenClaw Gateway 配置端口（实际绑 18791，status 显示有误差）

---

## 🎨 美术说明

- 当前美术：upstream 2026-03 全量重绘版（大橘猫风格）
- 旧版海星/小龙虾美术：已从 upstream 删除，可从 git history 找回
- 狐狸形象：已有设计稿，帧数要求高，暂未实现，通过资产侧边栏上传即可替换

---

## 📝 更新记录

- **2026-03-05 17:00** — merge-upstream-v2 完成上线；修复3个部署坑（见 README 事故记录）；HANDOVER.md 全量更新 ✅
- **2026-03-02 16:30** — Named Tunnel 配置完成，fengxiao.cc 上线 ✅
- **2026-03-01** — 项目创建，基础功能完成

---

*最后更新：2026-03-05 17:00 by 奉孝*
