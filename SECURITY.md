# Security Policy

## Supported Versions

We release patches for security vulnerabilities in actively maintained versions of MalRus.  
Currently supported versions:

| Version       | Supported |
| ------------- | --------- |
| master        | ✅        |
| old branches  | ❌        |

---

## Reporting a Vulnerability

> [!IMPORTANT]
>
> If you discover a security issue in MalRus, **do not open a public issue**.  
> Please report it responsibly.

To report a vulnerability:

1. Email the maintainer at **samanrayantv@gmail.com**.
2. Include:
   - A description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)

We will acknowledge receipt within **48 hours**, and aim to provide a fix within **7 days** depending on severity.

---

## Security Best Practices

> [!TIP]
>
> Always run MalRus in a controlled Termux environment with proper permissions.

- Keep Termux and packages (`bash`, `dialog`, `git`, `gh`) updated.
- Do not run MalRus with elevated privileges.
- Review quarantined files carefully before restoring.

---

## Disclosure Policy

> [!NOTE]
>
> We follow a **responsible disclosure** model.  
> Vulnerabilities will be fixed before public announcement.

- Critical issues may result in immediate patch releases.
- Non-critical issues will be scheduled for the next release cycle.

---

## Responsible Disclosure Timeline

> [!CAUTION]
>
> The following timeline applies to vulnerabilities reported privately:

- **Day 0**: Vulnerability reported to maintainers.  
- **Day 2**: Acknowledgement sent to reporter.  
- **Day 7**: Fix developed and tested.  
- **Day 10**: Patch released publicly.  
- **Day 14**: Security advisory published with details.  

> [!WARNING]
>
> If a vulnerability is exploited in the wild, disclosure may be accelerated immediately.

---

## Acknowledgements

> [!NOTE]
>
> Thanks to all contributors who help keep MalRus secure.
