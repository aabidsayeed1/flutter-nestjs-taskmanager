import { Namespace } from 'cls-hooked';

jest.mock('cls-hooked');

describe('TraceContext', () => {
	let mockNamespace: jest.Mocked<Namespace>;
	let mockGetNamespace: jest.Mock;
	let mockCreateNamespace: jest.Mock;

	beforeEach(() => {
		jest.resetModules();

		mockNamespace = {
			set: jest.fn(),
			get: jest.fn(),
			run: jest.fn(fn => fn())
		} as any;

		mockGetNamespace = jest.fn().mockReturnValue(undefined);
		mockCreateNamespace = jest.fn().mockReturnValue(mockNamespace);

		jest.doMock('cls-hooked', () => ({
			getNamespace: mockGetNamespace,
			createNamespace: mockCreateNamespace
		}));
	});

	describe('getNamespace', () => {
		it('should create a new namespace if it does not exist', () => {
			const { TraceContext } = require('./trace.context');
			const namespace = TraceContext.getNamespace();
			expect(namespace).toBe(mockNamespace);
			expect(mockCreateNamespace).toHaveBeenCalledWith('app');
		});

		it('should return existing namespace if it exists', () => {
			const { TraceContext } = require('./trace.context');
			mockGetNamespace.mockReturnValueOnce(mockNamespace);
			const namespace = TraceContext.getNamespace();
			expect(namespace).toBe(mockNamespace);
			expect(mockCreateNamespace).not.toHaveBeenCalled();
		});
	});

	describe('setTraceId', () => {
		it('should set trace ID in the namespace', () => {
			const { TraceContext } = require('./trace.context');
			TraceContext.setTraceId('test-trace-id');
			expect(mockNamespace.set).toHaveBeenCalledWith(
				'traceID',
				'test-trace-id'
			);
		});
	});

	describe('getTraceId', () => {
		it('should get trace ID from the namespace', () => {
			const { TraceContext } = require('./trace.context');
			mockNamespace.get.mockReturnValue('test-trace-id');
			const traceId = TraceContext.getTraceId();
			expect(traceId).toBe('test-trace-id');
			expect(mockNamespace.get).toHaveBeenCalledWith('traceID');
		});
	});

	describe('setSessionId', () => {
		it('should set session ID in the namespace', () => {
			const { TraceContext } = require('./trace.context');
			TraceContext.setSessionId('test-session-id');
			expect(mockNamespace.set).toHaveBeenCalledWith(
				'sessionID',
				'test-session-id'
			);
		});
	});

	describe('getSessionId', () => {
		it('should get session ID from the namespace', () => {
			const { TraceContext } = require('./trace.context');
			mockNamespace.get.mockReturnValue('test-session-id');
			const sessionId = TraceContext.getSessionId();
			expect(sessionId).toBe('test-session-id');
			expect(mockNamespace.get).toHaveBeenCalledWith('sessionID');
		});
	});

	describe('run', () => {
		it('should execute the provided callback in the namespace context', () => {
			const { TraceContext } = require('./trace.context');
			const mockCallback = jest.fn();
			TraceContext.run(mockCallback);
			expect(mockNamespace.run).toHaveBeenCalledWith(mockCallback);
			expect(mockCallback).toHaveBeenCalled();
		});
	});
});
