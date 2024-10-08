# Проект настройки GPU в Linux

Этот проект автоматизирует установку и настройку Linux-машины для задач, требующих высокой производительности GPU, включая удалённый доступ, драйверы GPU и установку программного обеспечения для разработки.

## Оглавление

- [Обзор](#обзор)
- [Структура проекта](#структура-проекта)
- [Конфигурация](#конфигурация)
- [Обзор этапов](#обзор-этапов)
  - [Этап 1: Настройка удалённого доступа](#этап-1-настройка-удалённого-доступа)
  - [Этап 2: Настройка системы](#этап-2-настройка-системы)
  - [Этап 3: Установка инструментов для разработки](#этап-3-установка-инструментов-для-разработки)
- [Как использовать](#как-использовать)
  - [Запуск конкретного этапа](#запуск-конкретного-этапа)
  - [Проверка состояния сервисов](#проверка-состояния-сервисов)
- [Удаление](#удаление)
- [Управление сервисами](#управление-сервисами)
- [Управление перезагрузкой](#управление-перезагрузкой)
- [Заключение](#заключение)

## Обзор

Этот проект предназначен для автоматизации настройки различных компонентов системы, необходимых для вычислений на основе GPU на Linux-машине. Проект разделён на три основных этапа, каждый из которых охватывает определённый аспект конфигурации системы. Также предусмотрены утилиты для управления перезагрузками и другими задачами обслуживания.

## Структура проекта

```
/setup/
│
├── stage_1_remote_access/
│   ├── check_service_status.sh
│   ├── clear_windows_manager.sh
│   ├── config.env
│   ├── install_firewall.sh
│   ├── install_rdp.sh
│   ├── install_samba.sh
│   ├── install_ssh.sh
│   ├── install_vnc.sh
│   ├── manage_services.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── setup_vnc_password.sh
│   ├── setup_vnc_service.sh
│   ├── uninstall_stage_1.sh
│
├── stage_2_system_setup/
│   ├── check_service_status.sh
│   ├── config.env
│   ├── install_cuda.sh
│   ├── install_cudnn.sh
│   ├── install_python.sh
│   ├── install_stage_2.sh
│   ├── manage_services_stage_2.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── uninstall_stage_2.sh
│
├── stage_3_dev_tools/
│   ├── check_service_status.sh
│   ├── config.env
│   ├── install_docker.sh
│   ├── install_git.sh
│   ├── install_jupyter.sh
│   ├── install_ray.sh
│   ├── install_stage_3.sh
│   ├── manage_services_stage_3.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── uninstall_stage_3.sh
│
└── utils/
    ├── reboot_if_needed.sh
    └── main.sh
```

## Конфигурация

Каждый этап имеет файл `config.env`, который управляет поведением скриптов. Убедитесь, что настроили эти файлы в соответствии с требованиями вашей системы перед запуском скриптов.

### Пример конфигурации для `config.env`

```ini
# Этап 1: Настройка удалённого доступа
RDP_ENABLE=true
VNC_ENABLE=false
WINDOW_MANAGER="xfce"

# Этап 2: Настройка системы
NVIDIA_DRIVER_ENABLE=true
NVIDIA_DRIVER_VERSION=525
CUDA_ENABLE=true
CUDA_VERSION=12-6
CUDA_DISTRIBUTION=ubuntu2404
CUDA_ARCH=x86_64
CUDNN_ENABLE=true
PYTHON_ENABLE=true
PYTHON_VERSION=3.11.9

# Этап 3: Установка инструментов для разработки
GIT_ENABLE=true
DOCKER_ENABLE=true
JUPYTER_ENABLE=true
JUPYTER_PORT=8888
RAY_ENABLE=true
```

## Обзор этапов

### Этап 1: Настройка удалённого доступа

Этот этап настраивает удалённый доступ к Linux-машине, включая службы RDP и VNC. Также можно настроить разные рабочие среды и управлять сервисами удалённого доступа.

- **Основные функции:**
  - Установка и настройка RDP (`xrdp`) с разными рабочими средами.
  - Установка и настройка VNC (`tightvncserver`).
  - Настройка фаервола для обеспечения безопасности.
  - Управление сервисами удалённого доступа и проверка их статуса.
  
[Описание этапа](./README_STAGE_1.md)

### Этап 2: Настройка системы

Этот этап фокусируется на установке драйверов GPU, CUDA, cuDNN и Python, чтобы подготовить машину для задач, использующих GPU.

- **Основные функции:**
  - Установка драйверов NVIDIA.
  - Установка набора инструментов CUDA и обеспечение доступности `nvcc`.
  - Установка библиотеки cuDNN для глубокого обучения.
  - Установка указанной версии Python и назначение его глобальным интерпретатором по умолчанию.

[Описание этапа](./README_STAGE_2.md)


### Этап 3: Установка инструментов для разработки

Этот этап включает установку различных инструментов для разработки и сред, необходимых для работы с машинным обучением и анализом данных, таких как Git, Docker, Jupyter и Ray.

- **Основные функции:**
  - Установка и настройка Git для управления версиями.
  - Установка и настройка Docker для контейнеризованных рабочих процессов.
  - Установка и настройка Jupyter Notebook/Lab на определённом порту.
  - Установка Ray для распределённых вычислений.

[Описание этапа](./README_STAGE_3.md)

## Как использовать

### Запуск конкретного этапа

Каждый этап содержит скрипт `run_stage.sh`, который выполняет установку и настройку компонентов для данного этапа.

1. **Сделайте скрипт исполняемым:**

   ```bash
   chmod +x run_stage.sh
   ```

2. **Запустите скрипт:**

   ```bash
   ./run_stage.sh
   ```

Это выполнит все необходимые шаги по установке компонентов для данного этапа на основе конфигурации в `config.env`.

### Проверка состояния сервисов

После выполнения установочных скриптов вы можете проверить статус установленных сервисов, запустив скрипт `check_service_status.sh` в каталоге каждого этапа:

```bash
./check_service_status.sh
```

Этот скрипт предоставит информацию о состоянии ключевых сервисов и проверит установленные версии критически важных компонентов, таких как Python и CUDA.

## Удаление

Для удаления установленных компонентов каждый этап содержит скрипт `uninstall_stage.sh`. Выполнение этого скрипта безопасно удалит компоненты, установленные на данном этапе.

```bash
./uninstall_stage.sh
```

## Управление сервисами

Скрипты управления сервисами позволяют запускать, останавливать и перезапускать сервисы, связанные с каждым этапом. Эти скрипты гарантируют, что сервисы вашей системы работают корректно после настройки.

- **Управление сервисами для Этапа 1:**

  ```bash
  ./manage_services.sh
  ```

- **Управление сервисами для Этапа 2:**

  ```bash
  ./manage_services_stage_2.sh
  ```

- **Управление сервисами для Этапа 3:**

  ```bash
  ./manage_services_stage_3.sh
  ```

## Управление перезагрузкой

Каталог `utils/` содержит скрипт для управления перезагрузкой, если это необходимо.

- **Перезагрузка системы при необходимости:**

  ```bash
  ./utils/reboot_if_needed.sh
  ```

## Заключение

Этот проект предоставляет структурированный и автоматизированный подход к настройке Linux-машины для задач, требующих интенсивного использования GPU. Разбиение настройки на этапы даёт гибкость и модульность, позволяя настраивать только нужные компоненты. Убедитесь, что настроили каждый файл `config.env` в соответствии с вашими требованиями перед запуском скриптов.