import { createNamespace, getNamespace, Namespace } from 'cls-hooked';

export class TraceContext {
	private static readonly NAMESPACE = 'app';
	private static readonly TRACE_ID_KEY = 'traceID';
	private static readonly SESSION_ID_KEY = 'sessionID';

	private static namespace: Namespace;

	static getNamespace(): Namespace {
		if (!this.namespace) {
			this.namespace =
				getNamespace(this.NAMESPACE) || createNamespace(this.NAMESPACE);
		}
		return this.namespace;
	}

	static setTraceId(traceId: string): void {
		this.getNamespace().set(this.TRACE_ID_KEY, traceId);
	}

	static getTraceId(): string | undefined {
		return this.getNamespace().get(this.TRACE_ID_KEY);
	}

	static setSessionId(sessionId: string): void {
		this.getNamespace().set(this.SESSION_ID_KEY, sessionId);
	}

	static getSessionId(): string | undefined {
		return this.getNamespace().get(this.SESSION_ID_KEY);
	}

	static run(callback: () => void): void {
		this.getNamespace().run(callback);
	}
}
